class TOC
  def nav_list(options = {})
    @nav_list ||= NavListBuilder.for(self, options)
  end

  class NavListBuilder < Traverser
    attr_reader :lines
    def initialize(options = {})
      super
      @options = options
      @lines = []
    end

    def begin_sublist(path)
      lines << '<ul>'
    end

    def accept_node(ancestors, node)
      rel_path = @options[:toc].section_path(node)
      link_path = @options[:link_path_template] % rel_path
      tag_body = '<a href="%s">%s</a>' % [link_path, node]
      tag_body << '&nbsp;<span class="current-marker">&larr;HEAD</span>' if current_section?(node)
      lines << '<li>%s</li>' % tag_body
    end

    def current_section_dasherized
      @current_section_dasherized ||= @options[:current_section].to_s.dasherize
    end

    def current_section?(section_name)
      section_name.dasherize == current_section_dasherized
    end

    def finalize_sublist(path)
      lines << '</ul>'
    end

    def to_html
      lines.join("\n")
    end
  end
end
