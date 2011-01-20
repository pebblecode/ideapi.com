class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :title
    end

    add_column :documents, :site_id, :integer
  end

  def self.down
    remove_column :documents, :site_id
    drop_table :sites
  end
end
