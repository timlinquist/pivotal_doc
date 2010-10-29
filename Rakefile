require 'spec/rake/spectask'
require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.name = "pivotal_doc"
    gem.summary = %Q{A release documentation generator for pivotaltracker.com}
    gem.description = %Q{
        Automated release notes for apps hosted on pivotaltracker.com.  
        Allows release notes to be generated for any project on pivotaltracker.com by retrieving the latest iteration for the specified project and displaying the completed features, bugs, and chores.
      }
    gem.email = "tim.linquist@gmail.com"
    gem.homepage = "http://github.com/timo3377/pivotal_doc"
    gem.authors = ["Tim Linquist"]
    gem.files.include %w(templates/ .gitignore assets/ ext/ lib/pivotal_doc/)

    gem.add_dependency "pivotal-tracker", ">= 0.2.1"
    gem.add_dependency "haml"
    gem.add_development_dependency "rspec"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

