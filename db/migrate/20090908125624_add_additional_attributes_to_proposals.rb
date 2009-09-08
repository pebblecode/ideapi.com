class AddAdditionalAttributesToProposals < ActiveRecord::Migration
  def self.up
    add_column :proposals, :published_at, :datetime
    add_column :proposals, :title, :string
  end

  def self.down
    remove_column :proposals, :title
    remove_column :proposals, :published_at
  end
end
