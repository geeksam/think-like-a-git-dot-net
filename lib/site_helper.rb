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

  def linear_nav_links
    prev_section, next_section = sitemap.prev_and_next(@page.title)
    clearer + tag(:div, nil, :class => 'linear_nav_links') {
      ''.tap { |s|
        s << tag(:a, '&larr; ' + prev_section, :href => '#', :class => 'prev') if prev_section
        s << tag(:a, next_section + ' &rarr;', :href => '#', :class => 'next') if next_section
      }
    }
  end
end

Webby::Helpers.register(SiteHelper)
