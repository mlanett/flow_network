module FlowNetwork
  
  
  # assume all sources have the same supply
  # assume all targets can consume all of it
  class FairTransportation
    
    
    class Edge < Struct.new( :source, :target, :flow )
      def to_s
        "(#{source}->#{target}@#{flow})"
      end
    end
    
    # sources is a map of sources and total flow for each one
    # targets is a map of targets and total flow for each one
    # paths is an array of Flow
    class Flows < Struct.new( :sources, :targets, :paths, :total )
      def dump
        print "Sources: ", sources.to_a.sort_by { |s| -s.last }.map { |s| s.join(":") }.join(", "), "\n"
        print "Targets: ", targets.to_a.sort_by { |s| -s.last }.map { |s| s.join(":") }.join(", "), "\n"
        print "Paths: \n"
        paths.sort_by { |path| -path.flow }.each { |p| puts p.to_s }
      end
    end

    
    attr :edges
    attr :sources
    attr :targets
    
    
    def initialize( supply, tuples )
      @supply = supply
      
      @edges        = []
      @source2edges = {}
      @target2edges = {}
      @demands      = Hash.new(0)
      @suppliers    = Hash.new(0)
      
      tuples.each do |tuple|
        edge = Edge.new( tuple.first, tuple.last, 0 )
        @edges << edge
        
        ( @source2edges[ edge.source ] ||= [] ) << edge
        ( @target2edges[ edge.target ] ||= [] ) << edge
        
        @demands[ edge.source ] += 1
        @suppliers[ edge.target ] += 1
      end
    end
    
    
    def compute_equally()
      @edges.each { |edge| edge.flow = 0 }
      
      # loop over each source, e.g. A, B, C
      @source2edges.each do |source,edges|
        demands = edges.size # e.g. source A has 3 demands
        supply = @supply / demands
        edges.each { |edge| edge.flow = supply }
      end
      
      get_flows()
    end
    
    
    def compute_skewed()
      # consider graph: A -> M, N, O; B -> N, P; C -> O
      # thus sources A, B, C have 3, 2, 1 demands
      # and targets M, N, O, P each have 1, 2, 2, 1 suppliers
      
      @edges.each { |edge| edge.flow = 0 }
      
      # loop over each source, e.g. A, B, C
      @source2edges.each do |source,edges|
        demands = edges.size # e.g. source A has 3 demands
        
        supplies = edges.inject(0) do |a,edge| 
          a + @target2edges[edge.target].size # e.g. total of A's targets (M,N,O) = 5
        end
        
        # now distribute A's share based on target weights
        edges.each do |edge| 
          edge.flow = @supply * @target2edges[edge.target].size / supplies
        end
      end
      
      get_flows()
    end # compute_skewed
    
    
    def get_flows()
      # return a Flows structure
      sources = Hash.new(0)
      targets = Hash.new(0)
      total   = 0
      paths   = []
      @edges.each do |edge|
        flow   = edge.flow
        sources[ edge.source ] += flow
        targets[ edge.target ] += flow
        total += flow
        paths << Edge.new( edge.source, edge.target, flow ) if flow > 0
      end
      paths = paths.sort_by { |path| path.flow }
      return Flows.new( sources, targets, paths, total )
    end # get_flows
    
    
  end # FairTransportation
  
end # FlowNetwork
