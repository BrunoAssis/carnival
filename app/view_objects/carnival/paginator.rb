module Carnival
  class Paginator

    def initialize(actual_page, last_page, max_fast_pages = 5)
      @actual_page = actual_page 
      @last_page = last_page >= 1 ? last_page : 1
      @max_fast_pages = max_fast_pages
    end

    def fast_pages_links_indexes
      fast_page_links = []
      first_index = -(@max_fast_pages/2)
      while fast_page_links.size < @max_fast_pages do
        fast_page = @actual_page + first_index
        break if fast_page > @last_page
        fast_page_links << fast_page if fast_page > 0
        first_index = first_index + 1
      end
      fast_page_links
    end
    
    def fast_pages_links_html
      htmls = []
      fast_pages_links_indexes.each do |page| 
        htmls << {:label => page, :css_class => get_css_class(page), :js_function => get_js_function(page)}
      end
      htmls
    end

    def get_js_function page
      "javascript:Carnival.goToPage(#{page})" 
    end

    def get_css_class page
      return 'carnival-selected-page-button' if page == @actual_page
      return 'carnival-page-button'
    end

    def previous_page
      return @actual_page if @actual_page - 1 < 1 
      @actual_page - 1
    end

    def next_page
      return @actual_page if @actual_page + 1 > @last_page 
      @actual_page + 1
    end

    def pages
      htmls = [] 
      htmls << {:label => ('paginate_first'), :js_function => get_js_function(1)}
      htmls << {:label => ('paginate_previous'), :js_function => get_js_function(previous_page)}
      htmls = htmls + fast_pages_links_html
      htmls << {:label => ('paginate_next'), :js_function => get_js_function(next_page)}
      htmls << {:label => ('paginate_last'), :js_function => get_js_function(@last_page)}
    end

  end
end
