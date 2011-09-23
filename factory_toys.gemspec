# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "factory_toys"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Henry", "Thomas Brand"]
  s.date = "2011-09-23"
  s.description = "Simplify Feature Management"
  s.email = "dw_henry@yahoo.com.au"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "factory_toys.gemspec",
    "lib/factory_toys.rb",
    "lib/factory_toys/f_factory.rb",
    "lib/factory_toys/parser.rb",
    "spec/factory_toys/f_factory_spec.rb",
    "spec/factory_toys/parser_spec.rb",
    "spec/factory_toys_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "tmp/features/simple_factory.feature",
    "tmp/ffactories/simple_factory.rb"
  ]
  s.homepage = "http://github.com/tom025/factory-toys"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Simplify Feature Management"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

