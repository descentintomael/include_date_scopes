$:.push File.expand_path("../lib", __FILE__)
require "include_date_scopes/version"

Gem::Specification.new do |s|
  s.name        = 'include_date_scopes'
  s.version     = IncludeDateScopes::VERSION.dup
  s.authors     = ['Sean Todd']
  s.email       = ['iphone.reply@gmail.com']
  s.homepage    = 'http://github.com/descentintomael/include_date_scopes'
  s.summary     = 'Include scopes for searching on a date column'
  s.description = <<-DESCRIPTION
Add in ActiveRelation scopes that are common across all models.  You can also 
add in a prefix to those scopes so you can have multiple per model.  See README
for more info.
DESCRIPTION

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", '< 4'
  s.add_dependency "railties"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'timecop'
end
