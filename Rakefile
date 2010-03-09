require 'rake'
require 'rake/gempackagetask'

GEM_ROOT     = File.dirname(__FILE__).freeze
VERSION_FILE = File.join(GEM_ROOT, 'lib', 'rumeme', 'version')

require VERSION_FILE

gemspec = Gem::Specification.new do |s|
  s.name        = 'rumeme'
  s.version     = Rumeme::VERSION
  s.summary     = 'Ruby SDK for Message Media SMS Gateway API'

  s.files        = FileList['[A-Z]*', 'lib/**/*.rb']
  s.require_path = 'lib'

  s.extra_rdoc_files = ['README.rdoc']
  s.rdoc_options = ['--line-numbers', "--main", "README.rdoc"]

  s.add_runtime_dependency('nokogiri', '1.4.1')

  s.authors = ['antlypls']
  s.email   = 'antlypls@gmail.com'
  s.homepage = 'http://github.com/programmable/rumeme'

  s.platform = Gem::Platform::RUBY
end

Rake::GemPackageTask.new gemspec do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end