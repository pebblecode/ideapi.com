class CreateCreativeResponses < ActiveRecord::Migration
  def self.up
    create_table :creative_responses, :force => true do |t|
      t.column :short_description, :text
      t.column :long_description, :text
      t.column :brief_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :creative_responses
  end
end
