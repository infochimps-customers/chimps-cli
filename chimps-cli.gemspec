# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$:.unshift(lib) unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name             = "chimps-cli"
  s.version          = File.read(File.expand_path("../VERSION", __FILE__))
  s.platform         = Gem::Platform::RUBY
  s.authors          = ["Dhruv Bansal"]
  s.email            = ["coders@infochimps.com"]
  s.homepage         = "http://github.com/infochimps/chimps-cli"
  s.summary          = "Chimps CLI is command-line interface for the Infochimps APIs"
  s.description      = "Chimps CLI provides the command-line program 'chimps' which allows you to easily make API calls against Infochimps web services, including searching, creating datasets, downloading, and querying data."
  s.extra_rdoc_files = ["README.rdoc"]
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- spec/*`.split("\n")
  s.require_paths    = ["lib"]
  s.executables      = ["chimps"]
  
  s.add_dependency "chimps", ">= 0.3.5"
  s.add_dependency "configliere", ">= 0.3.2"
  s.add_dependency "json"

  s.add_development_dependency "rspec", ">= 2.0.0"
end

