module TagHelper
  def tag(tag_name, tag_body, options = {})
    tag_name = tag_name.to_s
    tag_attrs = options.map { |k, v| %Q(#{k}="#{v}") }.join(' ')
    start_tag = [tag_name, tag_attrs].reject { |e| e =~ /^\s*$/ }.join(' ')
    end_tag = tag_name
    tag_body = (options[:format_string] % tag_body) if options[:format_string]
    %Q[<#{start_tag}>#{tag_body}</#{end_tag}>]
  end

  def div(body, options = {})
    tag :div, body, options
  end

  def span(body, options = {})
    tag :span, body, options
  end

  # def acronym(acronym, definition)
  #   tag(:acronym, acronym, :title => definition)
  # end
  # 
  # def grayed(text)
  #   tag(:span, text, :class => 'grayed')
  # end
end

Webby::Helpers.register(TagHelper)
