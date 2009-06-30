class AssociateTemplateQuestionsWithBriefItem < ActiveRecord::Migration
  def self.up
    add_column :brief_items, :template_question_id, :integer
  end

  def self.down
    remove_column :brief_items, :template_question_id
  end
end
