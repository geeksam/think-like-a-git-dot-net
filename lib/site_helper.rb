module SiteHelper
  def include_page(title)
    page = @pages.find( :title => title )
    render(page)
  end
end

Webby::Helpers.register(SiteHelper)
