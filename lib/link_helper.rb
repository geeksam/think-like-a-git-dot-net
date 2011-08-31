require 'lib/tag_helper'

module LinkHelper
  include TagHelper

  # def stylesheet_link(filename, media = 'screen')
  #   %Q[<link href="/public/stylesheets/#{filename}.css" media="#{media}" rel="Stylesheet" type="text/css" /> ]
  # end
  # 
  # def script_link(filename)
  #   %Q[<script src="/public/javascripts/#{filename}.js" type="text/javascript"></script>]
  # end

  def page(filename)
    @found_pages ||= {}
    @found_pages[filename] ||= @pages.find(:filename => filename)
  end

  # def nav_page_link(filename, link_text = nil)
  #   link_text ||= page(filename).title
  #   link_text = tag(:span, link_text)
  #   page_link(filename, link_text)
  # end

  def page_link(filename, link_text = nil)
    link_text ||= begin
      page(filename).title
    rescue Exception => e
      raise "no title on: #{page(filename)}"
    end
    link_to link_text, page(filename).url
  end
end

Webby::Helpers.register(LinkHelper)
