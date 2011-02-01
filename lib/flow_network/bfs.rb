require "flow_network/map"

module FlowNetwork
  module BreadthFirstSearch
  
    def find_path()
      raise if ! @start
      raise if ! @finish
    
      map  = Map.new # tracks backwards from given to previous
      path = [] # the points in the graph which we have reached and not yet eliminated
    
      # mark the origin so we don't think it's a new node
      map.visited @start, @start, :start
      path.push @start
    
      # consider all branches
      while path.size > 0 do
      
        # eliminating one by one
        start = path.shift
      
        from(start).reject { |finish| map.visited?(finish) }.each do |finish|
          edge = edge(start,finish)
        
          # if an edge's flow is below its capacity, we could increase it
          if edge.flow < edge.capacity then
            map.visited finish, start, :forward
            if finish == @finish then
              s = map.steps(@start,@finish)
              return s
            end
            path.push(finish)
          end # flow
        end # from
      
        # consider backwards edges
        to(start).reject { |finish| map.visited?(finish) }.each do |prestart|
          edge = edge(prestart,start)
        
          # if an edge has flow, we could steal from it
          if edge.flow > 0 then
            map.visited prestart, start, :backtrace
            path.push(prestart)
          end # flow
        end # to
      
      end # path
    
      return nil
    end # find_path
    
  end # BreadthFirstSearch
end # FlowNetwork
