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

base_url = "https://ruby-doc.org"

scraped_versions.each do |version_hash|
	# create Version
	version = Version.create!(number: version_hash[:number], scrape_url: version_hash[:url])
	classes_and_modules = version_hash[:classes] + version_hash[:modules]
	classes_and_modules.each do |class_or_module|
		is_main_menu = main_menu.include?(class_or_module[:name])
		# create Klass
		klass = Klass.create!(
			version: version,
			name: class_or_module[:name],
			summary: class_or_module[:summary],
			main_menu: is_main_menu,
			category: class_or_module[:type])
		# create sections (methods) for klass
		class_or_module[:methods].each do |method|
			Section.create!(
				name: method[:name],
				category: method[:category],
				klass: klass,
				summary: method[:summary],
				rubydocs_says: method[:content])
		end
	end
	
	# Add parents to each klass
	classes_and_modules.each do |class_or_module|
		klass = Klass.find_by(name: class_or_module[:name], version: version)
		parent_name = class_or_module[:parent]
		parent_klass = Klass.find_by(name: parent_name, version: version)
		if klass && parent_klass
			klass.update(parent: parent_klass)
		end
	end
end
