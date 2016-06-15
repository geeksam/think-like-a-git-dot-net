class TOC
  class SectionCreator < Traverser
    def accept_node(ancestors, node)
      slug = TOC.slug(ancestors, node)
      filename = filename_for(slug)
      return if File.exists?(filename)
      cmd = "webby create:section sections/#{slug}"
      puts cmd
      `#{cmd}`
    end

    def filename_for(slug)
      'content/sections/%s.txt' % slug
    end
  end
end
