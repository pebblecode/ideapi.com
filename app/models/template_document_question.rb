class TemplateDocumentQuestion < ActiveRecord::Base
  belongs_to :template_document
  belongs_to :template_question

  has_simple_ordering
  
  validates_presence_of :template_document_id, :template_question_id

  # Added by George Ornbo 19/07/10
  # This method allows an ajax put request to update the order of 
  # questions in a template document. The Template Document show view
  # allows editors to move questions up and down. This fires an ajax
  # request via jQuery which updates the ordering using this method
  # See /public/javascripts/jshizzle.js for the javascript 
  def self.order(ids)
    update_all(
      ['position = FIND_IN_SET(id, ?)', ids.join(',')],
      { :id => ids }
    )
  end


end
