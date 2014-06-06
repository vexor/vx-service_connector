# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vx/service_connector/version'

Gem::Specification.new do |spec|
  spec.name          = "vx-service_connector"
  spec.version       = Vx::ServiceConnector::VERSION
  spec.authors       = ["Dmitry Galinsky"]
  spec.email         = ["dima.exe@gmail.com"]
  spec.description   = %q{ vx-service_connector }
  spec.summary       = %q{ vx-service_connector }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'octokit',        '2.2.0'
  spec.add_runtime_dependency 'faraday',        '~> 0.9.0'
  spec.add_runtime_dependency 'activesupport',  '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   '2.14.0'
  spec.add_development_dependency "webmock"
end
