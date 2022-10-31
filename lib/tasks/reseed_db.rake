desc "Reseed the DB and fix content links"
task :reseed_db => [:environment] do
  scraped_data_filepath = 'lib/scraped_versions.yml'
  base_url = "https://ruby-doc.org"
  main_menu = %w(String Integer Array Hash Symbol)
  
  if File.exist?(scraped_data_filepath)
    puts "Getting data from saved scrape data"
    scraped_versions = YAML.load_file(scraped_data_filepath)
  else
    puts "You'll first need to scrape data --> first run rake :scrape_docs"
    next # exits rake task
  end

  ActiveRecord::Base.transaction do
    # Delete all data (Except users)
    puts "Destroying all Sections"
    Section.destroy_all
    puts "Destroying all Klasses"
    Klass.destroy_all
    puts "Destroying all Versions"
    Version.destroy_all

    # remove all redis background jobs
    puts "Redis flushall"
    $redis.flushall
    
    scraped_versions.each do |version_hash|
      # create Version
      puts "Creating version: #{version_hash[:number]}"
      version = Version.create!(number: version_hash[:number], scrape_url: version_hash[:url])
      classes_and_modules = version_hash[:classes] + version_hash[:modules]
      classes_and_modules.each do |class_or_module|
        is_main_menu = main_menu.include?(class_or_module[:name])
        # create Klass
        puts "- Creating klass: #{class_or_module[:name]}"
        klass = Klass.create!(
          version: version,
          name: class_or_module[:name],
          summary: class_or_module[:summary],
          main_menu: is_main_menu,
          category: class_or_module[:type])
        # create sections (methods) for klass
        class_or_module[:methods].each do |method|
          puts "-- Creating section: #{method[:name]}"
          Section.create!(
            name: method[:name],
            category: method[:category],
            klass: klass,
            summary: method[:summary],
            rubydocs_says: method[:content],
            source_code: method[:source_code])
        end
      end
      
      # Add parents to each klass
      classes_and_modules.each do |class_or_module|
        klass = Klass.find_by(name: class_or_module[:name], version: version)
        parent_name = class_or_module[:parent]
        parent_klass = Klass.find_by(name: parent_name, version: version)
        if klass && parent_klass
          puts "- Updating parent for klass: #{klass.name}"
          klass.update_column(:parent_id, parent_klass.id) #=> 'update_column' method to avoid callbacks in order to reindex all records to algolia later
        end
      end
    end

    GC.start
    
    # Update links to link to internal content
    Version.all.find_each(batch_size: 1) do |version|
      puts "- Updating section links for version: #{version.number}"
      version.sections.find_each(batch_size: 10) do |section|
        puts "- Updating links for section: #{section.name}"
        UpdateContentLinksJob.perform_now(section: section)
      end
    end

    # remove all redis background jobs
    puts "Redis flushall"
    $redis.flushall
    
    # Reindex algolia just to be sure
    # - clear index
    puts "Clearing Section index on algolia"
    Section.clear_index!
    puts "Clearing Klass index on algolia"
    Klass.clear_index!
    # - reindex
    puts "Reindexing Section on algolia"
    Section.reindex!
    puts "Reindexing Klass on algolia"
    Klass.reindex!
  end
end
