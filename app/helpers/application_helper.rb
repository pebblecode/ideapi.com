# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def submitter(text, options = {})
    options = { :class => "submit" }.merge(options)
    submit_tag text, options
  end

end
