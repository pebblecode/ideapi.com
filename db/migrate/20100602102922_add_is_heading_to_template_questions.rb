class AddIsHeadingToTemplateQuestions < ActiveRecord::Migration
  def self.up
    add_column :template_questions, :is_heading, :boolean, :default => false
  end

  def self.down
    remove_column :template_questions, :is_heading
  end
end
