module SiteHelper
  def include_page(title)
    page = @pages.find( :title => title )
    render(page)
  end

  def clearer(content = nil)
    tag :div, content, :class => 'clear'
  end

  def sitemap
    @sitemap ||= Sitemap.from_file('lib/sitemap.txt')
  end

  def nav_list
    sitemap.nav_list
  end
end

Webby::Helpers.register(SiteHelper)
