class Sitemap
  class PathMapBuilder < Traverser
    attr_reader :paths
    def initialize(*args)
      super
      @paths = {}
    end
    
    def accept_node(ancestors, node)
      base = node.dasherize
      rel_path = Sitemap.slug(ancestors, node)
      @paths[base] = rel_path
    end
  end
end
