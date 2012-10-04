# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "search_qd/version"

Gem::Specification.new do |s|
  s.name        = "search_qd"
  s.version     = SearchQd::VERSION
  s.authors     = ["kgalli"]
  s.email       = ["mail@kgalli.de"]
  s.homepage    = "https://github.com/kgalli/search_qd"
  s.summary     = %q{Quick and dirty fulltext search for an ActiveRecord model.}
  s.description = %q{SearchQd provides a search method for string/text columns of an ActiveRecord model. The search itself is handled via simple SQL LIKE statements. That is why it is called quick and dirty.}
 
  s.rubyforge_project = "search_qd"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"

  s.add_dependency "activerecord"
end
