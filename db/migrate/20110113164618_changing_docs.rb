class ChangingDocs < ActiveRecord::Migration
  def self.up
    execute 'delete from template_brief_questions where template_brief_id = 1'
  end

  def self.down
  end
end
