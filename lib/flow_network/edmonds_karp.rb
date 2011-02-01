require "flow_network/flow_network"
require "flow_network/bfs"

module FlowNetwork
  class EdmondsKarp < FlowNetwork
    include BreadthFirstSearch
  end # FordFulkerson
end

