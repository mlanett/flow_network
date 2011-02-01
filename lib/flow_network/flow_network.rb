require "flow_network/graph"

module FlowNetwork
  class FlowNetwork < Graph


    include Logger # trace


    class CFEdge < Struct.new :start, :finish, :capacity, :flow
      def to_s
        "(#{start}->#{finish}:#{flow}/#{capacity})"
      end
    end


    attr_accessor :start, :finish


    def initialize( source , start , finish )
      super(CFEdge)

      # create a new graph with given capacities and 0 flow
      if source then
        source.edges.each do |cedge|
          add( cedge.start, cedge.finish, cedge.value, 0 )
        end
      end

      # use new graph
      @start  = start
      @finish = finish
    end


    def compute()
      steps = nil
      loop do
        steps = find_path()
        break if ! steps
        process( steps )
      end
      self
    end


    # ----------------------------------------------------------------------------
    # Object
    # ----------------------------------------------------------------------------


    def to_s
      @edges.map { |e| 
        e.flow > 0 ? "#{e.start}->#{e.finish}:#{e.flow}/#{e.capacity}" : "#{e.start}->#{e.finish}:#{e.capacity}"
      }.join(",")
    end


    # ----------------------------------------------------------------------------
    private
    # ----------------------------------------------------------------------------


    def process(steps)

      # find the minimum additional capacity for this path
      deltas = steps.map { |s| step_delta(s) }
      delta  = deltas.min
      raise if ! delta || delta <= 0

      # apply it
      steps.each do |s|
        if s.notes.first == :forward then
          e = edge(s.start,s.finish)
          e.flow += delta
        else
          e = edge(s.finish,s.start)
          e.flow -= delta
        end
      end

    end # process


    def step_delta( step )
      if step.notes.first == :forward then
        # we can add flow from current up to capacity
        edge( step.start, step.finish ).capacity - edge( step.start, step.finish ).flow
      else
        # we can consume the entire flow (back down to 0) when going backwards
        edge( step.finish, step.start ).flow
      end
    end


  end # FlowNetwork
end # FlowNetwork
