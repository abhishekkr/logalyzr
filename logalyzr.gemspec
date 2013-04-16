# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logalyzr/version'

Gem::Specification.new do |gem|
  gem.name          = "logalyzr"
  gem.version       = Logalyzr::VERSION
  gem.authors       = ["abhishekkr"]
  gem.email         = ["abhikumar163@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{}
  #gem.homepage      = "https://github.com/ChaosCloud/logalyzr"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.executables   = %w( logalyzr )

  gem.add_runtime_dependency 'arg0', '>= 0.0.2'
end
