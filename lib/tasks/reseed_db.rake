def print_usage(description)
  mb = GetProcessMem.new.mb
  puts "--------------------------------------------------"
  puts "#{ description } - MEMORY USAGE(MB): #{ mb.round }"
  puts "--------------------------------------------------"
end

desc "Reseed the DB and fix content links"
task :reseed_db => [:environment] do
  print_usage("start")

  scraped_data_filepath = 'lib/scraped_versions.yml'
  base_url = "https://ruby-doc.org"
  main_menu = %w(String Integer Array Hash Symbol)
  
  print_usage("Loading scraped docs")

  if File.exist?(scraped_data_filepath)
    puts "Getting data from saved scrape data"
    scraped_versions = YAML.load_file(scraped_data_filepath).freeze
  else
    puts "You'll first need to scrape data --> first run rake :scrape_docs"
    next # exits rake task
  end

  print_usage("Loaded scraped docs")

  ActiveRecord::Base.transaction do
    # Delete all data (Except users)
    puts "Destroying all Sections"
    Section.delete_all
    puts "Destroying all Klasses"
    Klass.delete_all
    puts "Destroying all Versions"
    Version.delete_all

    print_usage("Start of scraped_versions loop")

    # create versions
    scraped_versions.lazy.each do |version|
      Version.create!(number: version[:number], scrape_url: version[:url])
      GC.start
    end

    Version.uncached do
      Version.find_each do |version|
        print_usage("before version hash: #{version.number}")
        version_hash = scraped_versions.detect{ |v_hash| v_hash[:number] == version.number }
        class_and_modules = version_hash[:classes] + version_hash[:modules]
        class_and_modules.lazy.each do |class_or_module|
          # print_usage("class_or_module: #{class_or_module[:name]}")
          Klass.create!(version: version,
                        name: class_or_module[:name],
                        summary: class_or_module[:summary],
                        main_menu: main_menu.include?(class_or_module[:name]),
                        category: class_or_module[:type])
          GC.start
        end
        print_usage("after version hash: #{version.number}")
      end
    end

    print_usage("before creating methods")
    Klass.uncached do
      Klass.joins(:version).pluck(:id, :name, :version_id, :'versions.number').lazy.each do |klass|
        version_hash = scraped_versions.lazy.detect{ |v_hash| v_hash[:number] == klass[3] }
        class_and_modules = version_hash[:classes] + version_hash[:modules]
        klass_hash = class_and_modules.lazy.detect{ |k_hash| k_hash[:name] == klass[1] }
        if klass_hash
          klass_hash[:methods].lazy.each do |method_hash|
            Section.create!(name: method_hash[:name],
                            category: method_hash[:category],
                            klass_id: klass[0],
                            summary: method_hash[:summary],
                            rubydocs_says: method_hash[:content],
                            source_code: method_hash[:source_code])
            GC.start
          end
        end
        print_usage("klass methods: #{klass[1]}")
        GC.start
      end
    end
    print_usage("after creating methods")

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
