# -*- encoding: utf-8 -*-
# stub: gherkin 4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "gherkin".freeze
  s.version = "4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["G\u00E1sp\u00E1r Nagy".freeze, "Aslak Helles\u00F8y".freeze, "Steve Tooke".freeze]
  s.date = "2016-04-10"
  s.description = "Gherkin parser".freeze
  s.email = "cukes@googlegroups.com".freeze
  s.homepage = "https://github.com/cucumber/gherkin".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.2.3".freeze
  s.summary = "gherkin-4.0.0".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.4"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.3"])
    s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.8", "< 0.8.8"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.3"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.8", "< 0.8.8"])
  end
end
