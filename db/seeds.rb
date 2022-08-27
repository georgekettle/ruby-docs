if Rails.env == "development"
	Section.destroy_all
	Klass.destroy_all
	Version.destroy_all
end

puts "Creating Ruby versions"
versions = ['2.6', '2.7', '3.0', '3.1']
versions.each do |version|
	Version.create!(number: version)
end
puts "Finished creating Ruby versions"

puts "Creating Ruby classes (Klass)"
klasses = %w(String Integer Array Hash Symbol)
Version.all.each do |version|
	klasses.each do |klass_name|
		puts "Creating #{klass_name} for ruby version #{version.number}"
		klass = Klass.create!(version: version, name: klass_name)
		ruby_klass = Object.const_get(klass_name)
		puts "- Creating instance methods"
		instance_methods = ruby_klass.instance_methods - Object.instance_methods
		instance_methods.each do |instance_method|
			puts "-- #{instance_method}"
			Section.create!(name: instance_method, category: "instance_method", klass: klass)
		end
		puts "- Creating class methods"
		class_methods = ruby_klass.methods(false)
		class_methods.each do |class_method|
			puts "-- #{class_method}"
			Section.create!(name: class_method, category: "class_method", klass: klass)
		end
	end
end