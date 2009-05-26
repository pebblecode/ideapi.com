class CreateBriefConfigs < ActiveRecord::Migration
  def self.up
    create_table :brief_configs, :force => true do |t|
      t.column :title, :string
    end
  end

  def self.down
    drop_table :brief_configs
  end
end
