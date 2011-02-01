module FlowNetwork
  class Map


    class Step < Struct.new :start, :finish, :notes
      def to_s
        "(#{start}-#{finish}:#{notes})"
      end
    end

    # Map records a set of locations, and how one got there
    # e.g. B from A, C from B, D from B
    # It can generate a trail from one location to another if it has a full series of steps for them
    # e.g. A -> B -> D
    # Each location can have notes, e.g. :forward, :backtrace

    def initialize
      @steps = {}
      @notes = {}
    end


    def visited( node , from , *notes )
      @steps[node] = from
      @notes[node] = notes
    end


    def visited?(node)
      @steps[node]
    end


    def steps( start , finish )
      path = []
      step2 = finish

      loop do
        # break if we're at the beginning or have a loop
        step1 = @steps[step2]
        break if ! step1 || step1 == step2

        path << Step.new(step1,step2,@notes[step2])

        step2 = step1
      end

      path.reverse
    end


    def trail( start , finish )
      path = []
      node = finish

      loop do
        # sanity check in case map is busted
        break if ! @steps[node]

        path << [ node , *(@notes[node]) ]
        break if node == start

        node = @steps[node]
      end

      path.reverse
    end


  end
end
