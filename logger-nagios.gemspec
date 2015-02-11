# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logger/nagios/version'

Gem::Specification.new do |spec|
    spec.name          = "logger-nagios"
    spec.version       = Logger::Nagios::VERSION
    spec.authors       = ["Jeremy Brinkley"]
    spec.email         = ["jbrinkley@evernote.com"]
    spec.summary       = %q{Provides a Logger interface to Nagios plugin output}
    spec.homepage      = "http://github.com/evernote/logger-nagios"
    spec.license       = "Apache-2"

    spec.files         = `git ls-files -z`.split("\x0")
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ["lib"]

    spec.add_development_dependency "bundler", "~> 1.7"
    spec.add_development_dependency "rake", "~> 10.0"
end
