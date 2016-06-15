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

  def toc
    @toc ||= TOC.from_file('lib/toc.txt')
  end

end

# Or, you can do the module thing.  Just keep in mind that these won't
# get reloaded automatically, so you'll need to restart middleman.
require_relative 'lib/site_helper'
module SiteHelper

  def section_link(section_title, text = nil, opts = {})
    # TODO: actually link to section
    text ||= section_title
    content_tag( :a, opts ) {
      content_tag( :strong ) { text.upcase }
    }
  end

  def linear_nav_links
    title = current_page.data.title
    prev_section_title, next_section_title = toc.prev_and_next(title)
    clearer + content_tag(:div, :class => 'linear_nav_links') {
      prev_section_link(prev_section_title) +
      next_section_link(next_section_title)
    }
  end

  def prev_section_link(section_title = nil, html_options = {})
    return "" if section_title.nil?
    href = section_path(section_title)
    html_options = html_options.merge(:href => href, :class => 'prev')
    "".tap { |s|
      s << content_tag(:a, html_options) { "&larr; " + section_title }
      s << tag(:link, :rel => 'prev', :href => href)
    }
  end
  def next_section_link(section_title = nil, html_options = {})
    return "" if section_title.nil?
    href = section_path(section_title)
    html_options = html_options.merge(:href => href, :class => 'next')
    "".tap { |s|
      s << content_tag(:a, html_options) { section_title + " &rarr;" }
      s << tag(:link, :rel => 'next', :href => href)
    }
  end

  def section_path(section_title)
    path = toc.section_path(section_title)
    if current_page.path =~ /epic/
      '#%s' % path
    else
      '/sections/%s.html' % path
    end
  end

end
helpers SiteHelper

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
