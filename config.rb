###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  def section_link(section_name, text = nil, opts = {})
    # TODO: actually link to section
    text ||= section_name
    content_tag( :a, opts ) {
      content_tag( :strong ) { text.upcase }
    }
  end

  def page_link(filename, link_text = nil)
    qualified_filename = "/#{filename}.html"
    page = sitemap.find_resource_by_path(qualified_filename)
    link_text ||= page.data[:title]
    link_to link_text, qualified_filename
  end

  def twitter_user(username)
    content_tag( :a, :href => "https://twitter.com/#{username}" ) {
      '@' + username.to_s
    }
  end

  def clearer(content = nil)
    content_tag( :div, :class => 'clear' ) { content.to_s }
  end
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
