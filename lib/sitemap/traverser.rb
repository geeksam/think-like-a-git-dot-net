class Sitemap
  class Traverser
    def self.for(sitemap, options = {})
      options[:sitemap] ||= sitemap
      new(options).tap { |t| t.traverse(sitemap) }
    end

    def initialize(*args)
      @options = args.pop if args.last.kind_of?(Hash)
    end

    def traverse(sitemap)
      sitemap.facilitate_traversal_of(self)
    end
    def begin_sublist(path)           ; end
    def accept_node(ancestors, node)  ; end
    def finalize_sublist(path)        ; end
  end

  def facilitate_traversal_of(traverser)
    traverse_sexp(traverser, sexp)
  end

  def traverse_sexp(traverser, sexp, ancestors = [])
    prev_leaf = nil
    traverser.begin_sublist ancestors
    sexp.each do |node|
      if node.kind_of? Array
        traverse_sexp traverser, node, (ancestors + [prev_leaf]).compact
      else
        traverser.accept_node(ancestors, node)
        prev_leaf = node
      end
    end
    traverser.finalize_sublist ancestors
  end
end
