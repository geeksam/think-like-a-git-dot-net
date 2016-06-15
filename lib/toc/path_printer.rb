class TOC
  # This was a one-off I wrote to move sections into subdirs.  Probably doesn't need to be maintained.
  class PathPrinter < Traverser
    def initialize(*args)
      super
      @paths = []
    end

    def accept_node(ancestors, node)
      path = ancestors.map(&:dasherize).join('/')
      base = node.dasherize
      @paths << path unless path.blank? || @paths.include?(path)

      src = SectionsPath + '/%s.txt' % base
      dst = SectionsPath + '/%s.txt' % [path, base].flatten.reject(&:blank?).join('/')
      puts "git mv #{src} #{dst}"
    end

    def print_mkdirs
      puts @paths.uniq.map { |e| "mkdir #{SectionsPath}/#{e}" }
    end
  end
end
