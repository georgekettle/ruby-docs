def print_usage(description)
  mb = GetProcessMem.new.mb
  puts "--------------------------------------------------"
  puts "#{ description } - MEMORY USAGE(MB): #{ mb.round }"
  puts "--------------------------------------------------"
end

desc "Update section links"
task :update_links => [:environment] do
  ActiveRecord::Base.transaction do
    Section.uncached do
      # Update links to link to internal content
      Section.find_each(batch_size: 20) do |section|
        print_usage("Updating section links: #{section.name}")
        UpdateContentLinksJob.perform_now(section: section)
        GC.start
      end
    end
  end
end