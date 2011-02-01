require "test_helper"

require "flow_network"

describe FlowNetwork::EdmondsKarp do
  
  describe "simple graphs" do
  
    before do
      @g = FlowNetwork::Graph.new

      @g.add "S", "A", 3
      @g.add "S", "B", 2

      @g.add "A", "C", 2
      @g.add "A", "D", 2
      @g.add "B", "C", 2
      @g.add "B", "D", 3

      @g.add "C", "T", 3
      @g.add "D", "T", 2
    end

    it "computes" do
      p = FlowNetwork::EdmondsKarp.new( @g, "S", "T" )
      p.compute
    end
  
  end
  
  describe "complex graphs" do
    
    before do
      @g = FlowNetwork::Graph.new
      @g.add "A", "B", 3
      @g.add "A", "D", 3
      @g.add "B", "C", 4
      @g.add "C", "A", 3
      @g.add "C", "D", 1
      @g.add "C", "E", 2
      @g.add "D", "E", 2
      @g.add "D", "F", 6
      @g.add "E", "B", 1
      @g.add "E", "G", 1
      @g.add "F", "G", 9
    end
    
    it "computes" do
      p = FlowNetwork::EdmondsKarp.new( @g, "A", "G" )
      p.compute
    end
    
  end
  
end
