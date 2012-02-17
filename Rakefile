require 'rake'
require 'rake/testtask'
require 'bundler/gem_tasks'

desc 'Test the rumeme gem'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
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
      abort
  end

  version = [major, minor, patch].compact.join('.')

  File.open(File.join("lib", "rumeme", "version.rb"), "w") do |f|
    f.write <<EOF
module Rumeme
  VERSION = "#{version}"
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

  system ["#{editor} #{file}",
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

#desc 'Preparing release'
#task :prepare_release, :part do |t, args|
#  Rake::Task['bump'].invoke(args[:part])
#  Rake::Task['change'].invoke
#  Rake::Task['push'].invoke
#end