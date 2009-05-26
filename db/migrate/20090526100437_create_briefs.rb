class CreateBriefs < ActiveRecord::Migration
  def self.up
    create_table :briefs, :force => true do |t|
      t.column :brief_config_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :briefs
  end
end
