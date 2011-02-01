module FlowNetwork
  class Graph


    class Edge < Struct.new :start, :finish, :value
      def to_s
        "(#{start}->#{finish}:#{value})"
      end
    end

    #
    # construction
    #


    def initialize( kindOfEdge = Edge )
      @sis   = {} # map integer start to VertexInfo
      @fis   = {} # map integer finish to VertexInfo
      @edges = []
      @edge  = kindOfEdge
    end


    def add( start , finish , *values )

      edge = @edge.new( start , finish , *values )

      si = @sis[start] || (@sis[start] = {})
      si[finish] = edge

      fi = @fis[finish] || (@fis[finish] = {})
      fi[start] = edge

      @edges << edge
      self
    end


    #
    # accessors
    #


    def edges
      @edges
    end


    # select a given edge
    def edge( start, finish )
      @sis[start][finish]
    end


    # select all edges starting at a given vertex
    def from( start )
      (v = @sis[start]) ? v.keys : []
    end


    # select all edges finishing at a given vertex
    def to( finish )
      (v = @fis[finish]) ? v.keys : []
    end


    def to_s
      @edges.join(",")
    end


  end # Graph
end # FlowNetwork
