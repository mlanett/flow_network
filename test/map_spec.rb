require "test_helper"

require "flow_network"

describe FlowNetwork::Map do
  
  it "has steps" do
    m = FlowNetwork::Map.new
    
    m.visited "S", "S", :start
    m.visited "B", "S", :forward
    m.visited "D", "B", :forward
    m.visited "T", "D", :forward
    
    m.steps( "S", "T" ).size.must_equal 3
  end
  
end
