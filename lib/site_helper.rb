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
    sitemap.nav_list(:current_section => section_name(@page.title))
  end

  def section_name(section_title)
    section_title.downcase.gsub(/ +/, '-')
  end

  def section_path(section_title)
    '/sections/%s.html' % section_name(section_title)
  end

  def linear_nav_links
    prev_section, next_section = sitemap.prev_and_next(@page.title)
    clearer + tag(:div, :class => 'linear_nav_links') {
      ''.tap { |s|
        s << tag(:a, '&larr; ' + prev_section, :href => section_path(prev_section), :class => 'prev') if prev_section
        s << tag(:a, next_section + ' &rarr;', :href => section_path(next_section), :class => 'next') if next_section
      }
    }
  end
end

Webby::Helpers.register(SiteHelper)
