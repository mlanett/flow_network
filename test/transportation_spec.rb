=begin
t = FlowNetwork::Transportation.new
tuples.map(&:first).uniq.each { |i| t.add_source i, :capacity => 1440 }; true
tuples.map(&:last).uniq.each { |i| t.add_target i, :capacity => 200 }; true
tuples.each { |tup| t.connect tup.first, tup.last }; true
map = t.compute_flows
=end

require "test_helper"

require "flow_network"

describe FlowNetwork::Transportation do
  
  it "takes a simple node-based graph and creates an edge-based graph" do
    
    t = FlowNetwork::Transportation.new
    
    t.add_source :a, :capacity => 10
    t.add_source :b, :capacity => 10
    t.add_source :c, :capacity => 20
    
    t.add_target :m, :capacity => 10
    t.add_target :n, :capacity => 10
    t.add_target :o, :capacity => 20
    
    t.connect :a, [ :m, :n ]
    t.connect :b, [ :m, :o ]
    t.connect :c, [ :n ]
    
    map = t.compute_flows
    map.total.must_equal 30
    total_out = map.sources.values.inject(0) { |a,i| a+i }
    total_in = map.targets.values.inject(0) { |a,i| a+i }
    total_out.must_equal total_in
    map.sources[:a].must_equal 10
    map.sources[:b].must_equal 10
    map.sources[:c].must_equal 10
    map.targets[:m].must_equal 10
    map.targets[:n].must_equal 10
    map.targets[:o].must_equal 10
  end
  
  it "takes a node-based graph and creates an edge-based graph" do
    
    t = FlowNetwork::Transportation.new
    
    t.add_source :a, :capacity => 20
    t.add_source :b, :capacity => 20
    t.add_source :c, :capacity => 20
    
    t.add_target :m, :capacity => 20
    t.add_target :n, :capacity => 10
    t.add_target :o, :capacity => 10
    t.add_target :p, :capacity => 10
    t.add_target :q, :capacity => 10
    
    t.connect :a, [ :m, :o ]
    t.connect :b, [ :m, :o, :p ]
    t.connect :c, [ :m, :n, :o, :p, :q ]
    
    map = t.compute_flows
    map.total.wont_equal 0
    map.paths.must_be_instance_of Array
    #map.paths.size.must_equal 10
  end
  
end
