module TagHelper
  def tag(tag_name, *body_and_options)
    tag_name = tag_name.to_s
    options  = body_and_options.extract_options!

    tag_attrs = options.map { |k, v| %Q(#{k}="#{v}") }.join(' ')
    start_tag = [tag_name, tag_attrs].reject { |e| e =~ /^\s*$/ }.join(' ')

    tag_body = body_and_options.shift
    tag_body = yield if block_given?
    tag_body = (options[:format_string] % tag_body) if options[:format_string]

    end_tag = tag_name
    %Q[<#{start_tag}>#{tag_body}</#{end_tag}>]
  end

  def div(body, options = {})
    tag :div, body, options
  end

  def span(body, options = {})
    tag :span, body, options
  end
end

Webby::Helpers.register(TagHelper)
