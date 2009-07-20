module LayoutHelper

  def side_bar(&block)
    capture_content_from_haml :side_bar, &block
  end
  
  def title_holder(&block)
    capture_content_from_haml :title_holder, &block
  end
  
  def what_user_is_doing(&block)
    capture_content_from_haml :what_user_is_doing, &block
  end
  
  def sub_nav(primary_links = {}, secondary_links = {})
    
  end
  
  def tab_link(text, link, options = {})
    link_unless_current(text, link, options)
  end
  
  def link_unless_current(text, link, options = {})
    options.reverse_merge!({:class => 'current'})
    link_to_unless_current(text, link, options) {|link| content_tag 'span', link, options}
  end
  
  private
  
  def capture_content_from_haml(title, &block)
    content_for title.to_sym do
      content_tag :div, :class => title do
        capture(&block)
      end
    end
  end

end