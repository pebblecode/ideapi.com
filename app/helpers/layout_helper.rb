module LayoutHelper

  def side_bar(&block)
    capture_content_from_haml :side_bar, &block
  end
  
  def title_holder(&block)
    capture_content_from_haml :title_holder, &block
  end
  
  def sub_nav(&block)
    capture_haml_into(:sub_nav) do
      capture(&block)
    end
  end
  
  def tab_link(text, link, options = {})
    link_unless_current(text, link, options)
  end
  
  def link_unless_current(text, link, options = {})    
    options.reverse_merge!({:class => 'current'})
    link_to_unless_current(text, link, options) {|link| content_tag 'span', link, options}
  end
    
  def breadcrumb_list
    list = content_tag(:span, "You are here:")
    list << content_tag(:ul, breadcrumbs(:separator => '<li>&gt;</li>'), :class => "breadcrumbs")
  
    content_tag :li, list
  end
  
  def distance_in_time_with_today(date, word = "ago")
    if date.today?
      "Today"
    else
      "#{time_ago_in_words(date)} #{word}"
    end
  end
  
  private
  
  def capture_haml_into(hook)
    content_for hook.to_sym do
      yield
    end
  end
  
  def capture_content_from_haml(title, &block)
    capture_haml_into(title) do
      content_tag :div, :class => title do
        capture(&block)
      end
    end
  end

end