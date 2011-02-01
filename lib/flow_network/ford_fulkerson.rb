require "flow_network/flow_network"
require "flow_network/dfs"

module FlowNetwork
  class FordFulkerson < FlowNetwork
    include DepthFirstSearch
  end # FordFulkerson
end # FlowNetwork
