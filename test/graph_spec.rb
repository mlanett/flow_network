require "test_helper"

require "flow_network"

describe FlowNetwork::Graph do
  
  it "has hops" do
    g = FlowNetwork::Graph.new
    
    g.add "Chicago", "San Diego", 1
    g.edge("Chicago", "San Diego").value.must_equal 1
    
    g.add "Chicago", "New York", 2
    g.edge("Chicago", "New York").value.must_equal 2
    
    g.from("Chicago").size.must_equal 2
    g.to("New York").size.must_equal 1
    g.to("Vegas").size.must_equal 0
    
  end
  
end
