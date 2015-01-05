# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/async/stretch/version'

Gem::Specification.new do |spec|
  spec.name          = "devise-async-stretch"
  spec.version       = Devise::Async::Stretch::VERSION
  spec.authors       = ["Daniel Westendorf"]
  spec.email         = ["daniel@prowestech.com"]
  spec.summary       = %q{Move password stretching into a background job for fast user creation.}
  spec.description   = %q{Uncompromised security for your user's passwords. Move password stretching into a background job for fast user creation, but maintainging safety.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "devise"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rails", "~> 4.2.0"
  spec.add_development_dependency "activejob"
  spec.add_development_dependency "mocha", "~> 0.11"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "sidekiq"
  spec.add_development_dependency "delayed_job_active_record"
end
