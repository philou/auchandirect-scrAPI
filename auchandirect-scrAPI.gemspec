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

  spec.add_dependency 'storexplore', '~> 0.2'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "guard-rspec", "~> 4.0"
  spec.add_development_dependency "net-ping", "~> 1.7"
  spec.add_development_dependency "spec_combos", "~> 0.2"

end
