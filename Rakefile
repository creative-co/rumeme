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

desc "Clean files generated by rake tasks"
task :clobber => [:clobber_package]

desc "Generate a gemspec file"
task :gemspec do
  File.open("#{gemspec.name}.gemspec", 'w') do |f|
    f.write gemspec.to_ruby
  end
end

desc "Bumps the version by a minor or patch version, depending on what was passed in."
task :bump, :part do |t, args|
  if Rumeme::VERSION  =~ /^(\d+)\.(\d+)\.(\d+)(?:\.(.*?))?$/
    major = $1.to_i
    minor = $2.to_i
    patch = $3.to_i
  else
    abort
  end

  case args[:part]
    when /minor/
      minor += 1
      patch = 0
    when /patch/
      patch += 1
    else
      abort
  end

  version = [major, minor, patch].compact.join('.')

  File.open(File.join("lib", "rumeme", "version.rb"), "w") do |f|
    f.write <<EOF
module Rumeme
  VERSION = "#{version}".freeze
end
EOF
  end
end

desc "Writes out the new CHANGELOG and prepares the release"
task :change do
  load 'lib/rumeme/version.rb'
  file    = "CHANGELOG"
  old     = File.read(file)
  version = Rumeme::VERSION
  message = "Bumping to version #{version}"

  File.open(file, "w") do |f|
    f.write <<EOF
Version #{version} - #{Date.today}
===============================================================================

#{`git log $(git tag | tail -1)..HEAD | git shortlog`}
#{old}
EOF
  end

  editor = ENV["EDITOR"] || 'kate'

  exec ["#{editor} #{file}",
        "git commit -aqm '#{message}'",
        "git tag -a -m '#{message}' v#{version}",
        "echo '\n\n\033[32mMarked v#{version} /' `git show-ref -s refs/heads/master` 'for release.\033[0m\n\n'"].join(' && ')
end

desc "Bump by a minor version (1.2.3 => 1.3.0)"
task :minor do |t|
  Rake::Task['bump'].invoke(t.name)
  Rake::Task['change'].invoke
end

desc "Bump by a patch version, (1.2.3 => 1.2.4)"
task :patch do |t|
  Rake::Task['bump'].invoke(t.name)
  Rake::Task['change'].invoke
end

desc "Push the latest version and tags"
task :push do
  system("git push origin master")
  system("git push origin $(git tag | tail -1)")
end

desc "Push gem to Gemcutter"
task :push_gem do
  system "echo '\n\n\033[41mRun: gem push #{gemspec.name}-#{gemspec.version}.gem\033[0m\n\n'"

  #abort("not implemented yet")
  #system("git push origin $(git tag | tail -1)")
end

desc 'release gem'
task :release, :part do |t, args|
  Rake::Task['bump'].invoke(args[:part])
  Rake::Task['change'].invoke
  Rake::Task['push'].invoke
  Rake::Task['push_gem'].invoke
end

