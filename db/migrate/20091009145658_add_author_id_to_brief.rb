class AddAuthorIdToBrief < ActiveRecord::Migration
  def self.up
    add_column :briefs, :author_id, :integer
  end

  def self.down
    remove_column :briefs, :author_id
  end
end
