# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rumeme"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["antlypls", "statique"]
  s.date = "2011-11-05"
  s.email = "antlypls@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["CHANGELOG", "Rakefile", "README.rdoc", "lib/rumeme/configuration.rb", "lib/rumeme/message_status.rb", "lib/rumeme/sms_interface.rb", "lib/rumeme/sms_message.rb", "lib/rumeme/sms_reply.rb", "lib/rumeme/validity_period.rb", "lib/rumeme/version.rb", "lib/rumeme.rb"]
  s.homepage = "http://github.com/programmable/rumeme"
  s.rdoc_options = ["--line-numbers", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Ruby SDK for Message Media SMS Gateway API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end
