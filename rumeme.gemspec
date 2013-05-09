# -*- encoding: utf-8 -*-

GEM_ROOT     = File.dirname(__FILE__).freeze
VERSION_FILE = File.join(GEM_ROOT, 'lib', 'rumeme', 'version')

require VERSION_FILE

Gem::Specification.new do |s|
  s.name = "rumeme"
  s.version = Rumeme::VERSION

  s.authors     = ["Anatoliy Plastinin, Cloud Castle LLC", "Stan Carver II, A1 Web Consulting"]
  s.email       = ["antlypls@gmail.com", "stan@a1webconsulting.com"]

  s.homepage = "http://github.com/programmable/rumeme"
  s.summary = "Ruby SDK for Message Media SMS Gateway API"
  s.description = "Ruby SDK for Message Media SMS Gateway API"

  s.add_development_dependency 'shoulda'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = %W(lib)
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options = ["--line-numbers", "--main", "README.md"]
end
