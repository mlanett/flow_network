require "flow_network/map"

module FlowNetwork
  module DepthFirstSearch

    # @return an array of steps, or nil
    def find_path()
      raise if ! @start
      raise if ! @finish

      map  = Map.new # tracks backwards from given to previous
      reachable = [] # the points in the graph which we have reached and not yet eliminated

      # mark the origin so we don't think it's a new node
      map.visited( @start, @start, :start )
      reachable.push( @start )

      # consider all branches
      while reachable.size > 0 do

        # eliminating one by one
        start = reachable.pop

        finishes = from(start).reject { |finish| map.visited?(finish) }
        finishes.each do |finish|
          e = edge(start,finish)

          # if an edge's flow is below its capacity, we could increase it
          if e.flow < e.capacity then

            map.visited( finish, start, :forward )

            if finish == @finish then
              # return an array of steps
              s = map.steps( @start, @finish )
              return s
            end

            reachable.push( finish )

          end # flow
        end # from

        # consider backwards edges
        finishes = to(start).reject { |finish| map.visited?(finish) }
        finishes.each do |after|
          e = edge(after,start)

          # if an edge has flow, we could steal from it
          if e.flow > 0 then

            map.visited( after, start, :backtrace )
            reachable.push( after )

          end # flow
        end # to

      end # reachable

      return nil
    end # find_path

  end
end # FlowNetwork
