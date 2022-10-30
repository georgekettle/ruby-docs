desc "Scrape ruby-doc.org for fresh data"
task :scrape_docs => [:environment] do
  scraped_data_filepath = 'lib/scraped_versions.yml'
  base_url = "https://ruby-doc.org"
  
  puts "Scraping fresh data from #{base_url}"
  # List of ruby versions to scrape
  version_numbers = Rails.env == 'development' ? ['3.1.2'] : ['2.6.10', '2.7.6', '3.0.4', '3.1.2']
  scraped_versions = version_numbers.map { |v| RubyDocsScraper.new(v).call }
  # write data so it can be used later
  File.open(scraped_data_filepath,"w"){|file| file.write(scraped_versions.to_yaml)}
end
