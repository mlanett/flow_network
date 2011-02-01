=begin
  This class will solve max flow transportation flow,
  for a graph which has direct connections only between source and target.
=end
module FlowNetwork
  class Transportation


    attr :total_flow


    Flows = Struct.new( :sources, :targets, :paths, :total )
    Flow = Struct.new( :source, :target, :flow )


    def initialize()
      # graph looks like:
      # START 0:100 Mark 0:100 iMark 0:f*100 iChicago 0:f*10 Chicago 0:10 FINISH

      @sources = {} # map from key to capacity
      @targets = {} # map from key to capacity
      @paths   = []
      @graph   = FordFulkerson.new( nil, START, FINISH )
      @max     = 0 # max along any transportation edge (source or target)
      @s_total = 0 # total source capacity
      @t_total = 0 # total target capacity
    end


    # e.g. source "Mark", :capacity => 100
    def add_source( key, options = {} )
      capacity        = options[:capacity] || 100
      @sources[ key ] = capacity
      @graph.add( START, key, capacity, 0 )

      @max = capacity if capacity > @max
      @s_total += capacity
    end


    def add_target( key, options = {} )
      capacity        = options[:capacity] || 100
      @targets[ key ] = capacity
      @graph.add( key, FINISH, capacity, 0 )

      @max = capacity if capacity > @max
      @t_total += capacity
    end


    # e.g. connect "Mark", "Chicago"
    # or connect "Mark", "Chicago", "San Francisco"
    # or connect "Mark", [ "Chicago", "San Francisco" ]
    def connect( source, target )
      if target.kind_of? Enumerable then
        target.each do |it|
          connect( source, it )
        end
        return
      end

      raise if ! @sources[ source ]
      raise if ! @targets[ target ]

      # connect Mark (100) to Chicago (1000)
      # use an edge with the maximum possible capacity
      @graph.add( source, target, @max, 0 )
      @paths << [ source, target ]
    end


    def compute_flows()
      @graph.compute()
      map = get_flows()

      map[:sources].each { |source,flow| trace :transport, "Source #{source} Flow #{flow}" }
      map[:targets].each { |target,flow| trace :transport, "Target #{target} Flow #{flow}" }
      trace :transport, "Flow #{map[:total]} out of capacity #{@s_total} and demand #{@t_total}"

      return map
    end


    # return a simple map of targets and sources,
    # e.g.
    # [ source1, target1, flow ]*
    def get_flows()
      # return a Flows structure
      # sources is a map of sources and total flow for each one
      # targets is a map of targets and total flow for each one
      # paths is an array of Flow
      sources = Hash.new(0)
      targets = Hash.new(0)
      total   = 0
      paths   = []
      @paths.each do |entry|
        source = entry.first
        target = entry.last
        flow   = @graph.edge( source, target ).flow
        sources[ source ] += flow
        targets[ target ] += flow
        total             += flow
        paths << Flow.new( source, target, flow ) if flow > 0
      end
      return Flows.new( sources, targets, paths, total )
    end


    def graph
      @graph
    end


    # ----------------------------------------------------------------------------
    private
    # ----------------------------------------------------------------------------


    START  = :start
    FINISH = :finish


    def i(key)
      "#{key}*"
    end


    include Logger # trace


  end # Transportation
end # FlowNetwork
