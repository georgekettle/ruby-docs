if Rails.env == "development"
	Section.destroy_all
	Klass.destroy_all
	Version.destroy_all
	User.destroy_all
end

puts "Creating admin user"
password = "secret"
admin = User.create!(email: "test@test.com", password: password, admin: true)
puts "- Created user with email: #{admin.email} & password: #{password}"
puts "Finished creating admin user"

# List of ruby versions to scrape
version_numbers = ['3.1.2']
main_menu = %w(String Integer Array Hash Symbol)
scraped_versions = version_numbers.map { |v| RubyDocsScraper.new(v).call }

scraped_versions.each do |version_hash|
	# create Version
	version = Version.create!(number: version_hash[:number])
	version_hash[:classes].each do |class_hash|
		is_main_menu = main_menu.include?(class_hash[:name])
		# create Klass
		klass = Klass.create!(
			version: version,
			name: class_hash[:name],
			summary: class_hash[:summary],
			main_menu: is_main_menu)
		class_hash[:methods].each do |method|
			Section.create!(
				name: method[:name],
				category: method[:category],
				klass: klass,
				summary: method[:summary],
				rubydocs_says: method[:content])
		end
	end
end