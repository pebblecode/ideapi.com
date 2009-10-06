class AddIndexes < ActiveRecord::Migration
  
  def self.up
    add_index :brief_user_views, :brief_id
    add_index :brief_user_views, :user_id
    add_index :proposals, :brief_id
    add_index :proposals, :user_id
    add_index :questions, :brief_id
    add_index :questions, :user_id
    add_index :questions, :brief_item_id
    add_index :watched_briefs, :brief_id
    add_index :watched_briefs, :user_id
    add_index :friendships, :user_id
    add_index :friendships, :friend_id
    add_index :briefs, :user_id
    add_index :briefs, :site_id
    add_index :briefs, :template_brief_id
    add_index :briefs, :approver_id
    add_index :timeline_events, :subject_id
    add_index :timeline_events, :actor_id
    add_index :timeline_events, :secondary_subject_id
    add_index :template_brief_questions, :template_brief_id
    add_index :template_brief_questions, :template_question_id
    add_index :brief_item_versions, :brief_id
    add_index :brief_item_versions, :template_question_id
    add_index :invitations, :user_id
    add_index :invitations, :redeemed_by_id
    add_index :invitations, :redeemable_id
    add_index :brief_items, :brief_id
    add_index :brief_items, :template_question_id
    add_index :template_questions, :template_section_id
    add_index :template_briefs, :site_id
  end

  def self.down
    remove_index :brief_user_views, :brief_id
    remove_index :brief_user_views, :user_id
    remove_index :proposals, :brief_id
    remove_index :proposals, :user_id
    remove_index :questions, :brief_id
    remove_index :questions, :user_id
    remove_index :questions, :brief_item_id
    remove_index :watched_briefs, :brief_id
    remove_index :watched_briefs, :user_id
    remove_index :friendships, :user_id
    remove_index :friendships, :friend_id
    remove_index :briefs, :user_id
    remove_index :briefs, :site_id
    remove_index :briefs, :template_brief_id
    remove_index :briefs, :approver_id
    remove_index :timeline_events, :subject_id
    remove_index :timeline_events, :actor_id
    remove_index :timeline_events, :secondary_subject_id
    remove_index :template_brief_questions, :template_brief_id
    remove_index :template_brief_questions, :template_question_id
    remove_index :brief_item_versions, :brief_id
    remove_index :brief_item_versions, :template_question_id
    remove_index :invitations, :user_id
    remove_index :invitations, :redeemed_by_id
    remove_index :invitations, :redeemable_id
    remove_index :brief_items, :brief_id
    remove_index :brief_items, :template_question_id
    remove_index :template_questions, :template_section_id
    remove_index :template_briefs, :site_id
  end
  
end
