module ApplicationHelper

  # These methods support dynamic adding and removing of nested objects
  # Taken from http://github.com/timriley/complex-form-examples
  def remove_child_link(name, f)
    f.hidden_field(:_delete) + link_to(name, "javascript:void(0)", :class => "remove_child")
  end
  
  def add_child_link(name, association)
    link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
  end
  
  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f
    
    content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        render(:partial => options[:partial], :locals => {options[:form_builder_local] => f})
      end
    end
  end
  
  def comment_date(time)
    if time.to_date == Date.today
      time.strftime("at %R")
    else
      time.strftime("on %a #{time.day.ordinalize} %b %y")
    end
  end
  def domain_with_port(domain)
    port = self.request.port
    if RAILS_ENV == "development"
      "http://#{domain}:#{port}"
    else
      "http://#{domain}"
    end
  end
  
end
