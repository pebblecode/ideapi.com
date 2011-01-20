class AddDefaultTextToTemplateQuestions < ActiveRecord::Migration
  def self.up
    add_column :template_questions, :default_content, :text
  end

  def self.down
    remove_column :template_questions, :default_content
  end
end
