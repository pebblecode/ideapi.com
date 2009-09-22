class CleanUpProposals < ActiveRecord::Migration
  def self.up
    remove_column :proposals, :attachment_file_name
    remove_column :proposals, :attachment_content_type
    remove_column :proposals, :attachment_file_size
    remove_column :proposals, :attachment_updated_at
  end

  def self.down
    add_column :proposals, :attachment_updated_at, :datetime
    add_column :proposals, :attachment_file_size, :integer
    add_column :proposals, :attachment_content_type, :string
    add_column :proposals, :attachment_file_name, :string
  end
end
