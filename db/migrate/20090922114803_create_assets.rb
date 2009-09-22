class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.references :attachable, :polymorphic => true
      t.timestamps
    end
    
    add_index :assets, :attachable_id
  end

  def self.down
    drop_table :assets
  end
end
