if Rails.env == "development"
	Section.destroy_all
	Klass.destroy_all
	Version.destroy_all
end

puts "Creating Ruby versions"
versions = [RUBY_VERSION.match(/\d\.\d/)[0]]
versions.each do |version|
	Version.create!(number: version)
end
puts "Finished creating Ruby versions"

puts "Creating Ruby classes (Klass)"
klasses = %w(String Integer Array Hash Symbol)
Version.all.each do |version|
	# build Object
	puts "Creating Object for ruby version #{version.number}"
	object = Klass.create!(name: "Object", version: Version.first, summary: "Object is the default root of all Ruby objects. All classes inherit from Object and this makes all Object methods available unless explicitly overridden.")
	puts "- Creating instance methods"
	Object.instance_methods.each do |instance_method|
		puts "-- #{instance_method}"
		Section.create!(name: instance_method, category: "instance_method", klass: object, summary: "Random default summary")
	end
	puts "- Creating class methods"
	Object.methods(false).each do |class_method|
		puts "-- #{class_method}"
		Section.create!(name: class_method, category: "class_method", klass: object, summary: "Random default summary")
	end

	# build klasses that inherit from Object
	klasses.each do |klass_name|
		puts "Creating #{klass_name} for ruby version #{version.number}"
		klass = Klass.create!(version: version, name: klass_name, summary: "Random default summary", parent: object, main_menu: true)
		ruby_klass = Object.const_get(klass_name)
		puts "- Creating instance methods"
		instance_methods = ruby_klass.instance_methods - Object.instance_methods
		instance_methods.each do |instance_method|
			puts "-- #{instance_method}"
			Section.create!(name: instance_method, category: "instance_method", klass: klass, summary: "Random default summary")
		end
		puts "- Creating class methods"
		class_methods = ruby_klass.methods(false)
		class_methods.each do |class_method|
			puts "-- #{class_method}"
			Section.create!(name: class_method, category: "class_method", klass: klass, summary: "Random default summary")
		end
	end
end