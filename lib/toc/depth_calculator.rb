class TOC
  class DepthCalculator < Traverser
    attr_reader :depths
    def initialize(*args)
      super
      @depths = {}
    end
    def accept_node(ancestors, node)
      @depths[node] = ancestors.length + 1
    end
  end
end
