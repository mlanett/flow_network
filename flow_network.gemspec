# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flow_network/version"

Gem::Specification.new do |s|
  s.name        = "flow_network"
  s.version     = FlowNetwork::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Mark Lanett"]
  s.email       = ["mark.lanett@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{some network flow algorithms}
  s.description = ""

  s.rubyforge_project = "flow_network"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
