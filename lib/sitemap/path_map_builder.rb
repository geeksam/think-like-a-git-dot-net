class Sitemap
  class PathMapBuilder < Traverser
    attr_reader :paths
    def initialize(*args)
      super
      @paths = {}
    end
    
    def accept_node(ancestors, node)
      base = node.dasherize
      rel_path = (ancestors.map(&:dasherize) + [base]).join('/')
      @paths[base] = rel_path
    end
  end
end
