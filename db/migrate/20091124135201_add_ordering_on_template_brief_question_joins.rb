class AddOrderingOnTemplateBriefQuestionJoins < ActiveRecord::Migration
  def self.up
    add_column :template_brief_questions, :position, :integer
  end

  def self.down
    remove_column :template_brief_questions, :position
  end
end
