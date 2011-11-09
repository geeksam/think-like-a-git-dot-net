class Sitemap
  class SectionCreator < Traverser
    def accept_node(_, node)
      filename = filename_for(node)
      return if File.exists?(filename)
      cmd = "webby create:page sections/#{node.gsub(' ', '\ ')}"
      puts cmd
      `#{cmd}`
    end

    def filename_for(node)
      'content/sections/%s.txt' % node.dasherize
    end
  end
end
