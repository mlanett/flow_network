module FlowNetwork
  class PushRelabelTransportation

    def initialize()
      @sources = {}
      @targets = {}
      @paths   = []
      @inward  = {}
      @outward = {}
    end

    def add_source( source, options = {} )
      capacity = options[:capacity] || 100
      @sources[ source ] = capacity
      @inward[ source ]  = []
      @outward[ source ] = []
    end

    def add_target( target, options = {} )
      capacity = options[:capacity] || 100
      @targets[ target ] = capacity
      @inward[ target ]  = []
      @outward[ target ] = []
    end

    def connect( source, target )
      target.each { |t| connect( source, t ) } and return if target.respond_to?(:each)
      raise unless @sources[source]
      raise unless @targets[target]
      @paths << [ source, target ]
    end

    def compute_flows
    end
    
    private
    
    def capacity( u, v )
    end
    
    def flow( u, v )
    end
    
    def height( u, v  )
    end
    
    def excess( u )
    end
    
    def push( u, v )
    end
    
    def relabel( u )
    end
    
  end # PushRelabelTransportation
end # FlowNetwork
