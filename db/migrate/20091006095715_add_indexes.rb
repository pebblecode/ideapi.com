class AddIndexes < ActiveRecord::Migration
  
  def self.up
    
    add_index :assets, [:attachable_id, :attachable_type]
    
    add_index :invitations, [:redeemable_id, :redeemable_type]
       
    add_index :timeline_events, [:secondary_subject_id, :secondary_subject_type], :name => 'index_timeline_events_ssubs'
    add_index :timeline_events, [:subject_id, :subject_type]
    add_index :timeline_events, [:actor_id, :actor_type]
    
    add_index :document_user_views, :document_id
    add_index :document_user_views, :user_id
    
    add_index :proposals, :document_id
    add_index :proposals, :user_id
    
    add_index :questions, :document_id
    add_index :questions, :user_id
    add_index :questions, :document_item_id
    
    add_index :watched_documents, :document_id
    add_index :watched_documents, :user_id
    
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    
    add_index :documents, :user_id
    add_index :documents, :site_id
    add_index :documents, :template_document_id
    add_index :documents, :approver_id

    add_index :template_document_questions, :template_document_id
    add_index :template_document_questions, :template_question_id

    add_index :document_item_versions, :document_id
    add_index :document_item_versions, :template_question_id

    add_index :invitations, :user_id
    add_index :invitations, :redeemed_by_id
    add_index :invitations, :redeemable_id

    add_index :document_items, :document_id
    add_index :document_items, :template_question_id

    add_index :template_questions, :template_section_id
    add_index :template_documents, :site_id
  end

  def self.down
    remove_index :invitations, [:redeemable_id, :redeemable_type]
    remove_index :assets, [:attachable_id, :attachable_type]
    
    remove_index :timeline_events, [:secondary_subject_id, :secondary_subject_type]
    remove_index :timeline_events, [:subject_id, :subject_type]
    remove_index :timeline_events, [:actor_id, :actor_type]
    
    remove_index :document_user_views, :document_id
    remove_index :document_user_views, :user_id

    remove_index :proposals, :document_id
    remove_index :proposals, :user_id

    remove_index :questions, :document_id
    remove_index :questions, :user_id
    remove_index :questions, :document_item_id

    remove_index :watched_documents, :document_id
    remove_index :watched_documents, :user_id

    remove_index :friendships, :user_id
    remove_index :friendships, :friend_id

    remove_index :documents, :user_id
    remove_index :documents, :site_id
    remove_index :documents, :template_document_id
    remove_index :documents, :approver_id

    remove_index :template_document_questions, :template_document_id
    remove_index :template_document_questions, :template_question_id

    remove_index :document_item_versions, :document_id
    remove_index :document_item_versions, :template_question_id

    remove_index :invitations, :user_id
    remove_index :invitations, :redeemed_by_id
    remove_index :invitations, :redeemable_id

    remove_index :document_items, :document_id
    remove_index :document_items, :template_question_id

    remove_index :template_questions, :template_section_id
    remove_index :template_documents, :site_id
  end
  
end
