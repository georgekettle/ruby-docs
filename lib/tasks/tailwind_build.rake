namespace :tailwind do
  desc "Build your Tailwind bundle"
  task :build do
    system "yarn install" or raise
    system "yarn run build:tailwind" or raise
  end

  desc "Remove Tailwind builds"
  task :clobber do
    rm_rf Dir["app/assets/builds/tailwind.css"], verbose: false
  end
end

Rake::Task["assets:precompile"].enhance(["tailwind:build"])
Rake::Task["test:prepare"].enhance(["tailwind:build"])
Rake::Task["assets:clobber"].enhance(["tailwind:clobber"])