require 'rubygems'
require 'rake'

begin
  # http://github.com/technicalpickles/jeweler
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "chimps-cli"
    gem.summary = "Chimps CLI is command-line interface for the Chimps gem (http://www.infochimps.com/labs)"
    gem.description = "Chimps CLI provides the command line program 'chimps' which allows you to easily make API calls against Infochimps web services."
    gem.email = "coders@infochimps.com"
    gem.homepage = "http://github.com/infochimps/chimps-cli"
    gem.authors = ["Dhruv Bansal"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available.  Install it with: sudo gem install jeweler"
end

desc "Build tags"
task :tags do
  system "etags -R README.rdoc bin lib spec"
end

