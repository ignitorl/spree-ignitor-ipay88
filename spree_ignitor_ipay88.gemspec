$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spree_ignitor_ipay88/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "spree_ignitor_ipay88"
  s.version     = SpreeIgnitorIpay88::VERSION
  s.authors     = ["Edutor Technologies","Ignitor learning","Sriharsha Chintalapati"]
  s.email       = ["info@ignitorlearning.com"]
  s.homepage    = "http://www.ignitorlearning.com"
  s.summary     = "Ipay88 payment gateway support for Spree commerce engine"
  s.description = "Ipay88 is a payment gateway service in South East Asian countries. This gem provides integration support for Spree with the gateway"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements = 'none'

  s.add_dependency "spree_core", "~> 3.0" 
# This depends on rails 4.2 . The extension has taken advantage of some of the new features offered by Rails 4

  s.add_development_dependency "sqlite3","~>1.3"
  s.add_development_dependency "minitest", "~>5.9"
  s.add_development_dependency 'gem-release',"~>0.7"
end
