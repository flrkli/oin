module ApplicationHelper
  
  def create_navigation_links(navigation, links)
    @links = []
    links.each do |link|
      if link.class == Array
        link.each do |link_in_group|
          @links += [link_in_group]
          if link_in_group == link.first
            @links.last.html_options[:class] = "first "+@links.last.html_options[:class]
          end
          if link_in_group == link.last
            @links.last.html_options[:class] = "last "+@links.last.html_options[:class]
          end
          @links.last.html_options[:class] += " in_group"
        end
      else
        @links += [link]
        if link == links.first
          @links.last.html_options[:class] = "first "+@links.last.html_options[:class]
        end
      end
    end
  end
  
  def string_from_time(time)
    if time.class == Date
      time.strftime("%d.%m.%Y")
    else
      time.strftime("%A, %d.%m.%Y, %H:%M:%S Uhr")
    end
  end
  
end
