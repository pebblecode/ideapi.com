class Brief < ActiveRecord::Base

  # validations
  validates_presence_of :template_brief_id, :title, :most_important_message, :author_id

  def json_errors
    self.errors.full_messages
  end

end