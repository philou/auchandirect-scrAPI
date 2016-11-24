# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auchandirect/scrAPI/version'

Gem::Specification.new do |spec|
  spec.name          = "auchandirect-scrAPI"
  spec.version       = Auchandirect::ScrAPI::VERSION
  spec.authors       = ["Philou"]
  spec.email         = ["philippe.bourgau@gmail.com"]
  spec.description   = %q{Through scrapping, an API to the french www.auchandirect.fr online grocery}
  spec.summary       = %q{auchandirect.com grocery API}
  spec.homepage      = "https://github.com/philou/auchandirect-scrAPI"
  spec.license       = "LGPL v3"

  spec.files         = `git ls-files`.split($/).reject {|f| f.match(/^offline_sites/)}
  spec.require_paths = ["lib"]

  spec.add_dependency 'storexplore', '~> 0.4'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "net-ping"
  spec.add_development_dependency "spec_combos"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter"

end
