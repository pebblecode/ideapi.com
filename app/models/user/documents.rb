class User < ActiveRecord::Base

  named_scope :authors, :conditions => 'user_documents.author = true'

  def watch(document)
    return false if !document
    
    if document.published?
      watched_documents.create(:document => document) unless self.owns?(document)
    else
      errors.add_to_base("You cannot watch a document which isn't currently published")
      false
    end
  end
  
  def toggle_watch!(document)
    watching?(document) ? watching.delete(document) : watch(document)
  end
  
  def watching?(document)
    watching.include?(document)
  end
  
  def pitching?(document)
    responded_documents.include?(document)
  end
  
  def proposal_for(document)
    proposals.find_by_document_id(document)
  end
  
  def respond_to_document(document)
    if document.published?
      transaction do
        watching.delete(document)
        proposals.create(:document => document, :title => "Your response to #{document.title}", :long_description => "Enter your response here")
      end      
    else
      errors.add_to_base("You cannot respond to a document which isn't currently published")
      false
    end
  end
  
  def author?
    published.present?
  end
  
  def owns?(thing)
    assoc = thing.class.to_s.tableize
    respond_to?(assoc) && send(assoc).include?(thing)
  end
  
  def documents_grouped_by_state
    returning(DocumentCollection.new) do |collection|
      hash = documents.all.group_by(&:state)
      hash[:watching] = watching if !watching.empty?
      hash[:pitching] = pitching if !pitching.empty?
      
      collection.populate(hash)
    end
  end
  
  def last_viewed_document(document)
    if view = document_user_views.find_by_document_id(document)
      view.last_viewed_at
    else
     1.year.ago
    end
  end

end