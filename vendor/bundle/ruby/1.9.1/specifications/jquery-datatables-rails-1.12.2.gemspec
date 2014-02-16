# -*- encoding: utf-8 -*-
# stub: jquery-datatables-rails 1.12.2 ruby lib

Gem::Specification.new do |s|
  s.name = "jquery-datatables-rails"
  s.version = "1.12.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Robin Wenglewski"]
  s.date = "2013-11-24"
  s.description = ""
  s.email = ["robin@wenglewski.de"]
  s.homepage = "https://github.com/rweng/jquery-datatables-rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "jquery datatables for rails"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
    else
      s.add_dependency(%q<jquery-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<jquery-rails>, [">= 0"])
  end
end
