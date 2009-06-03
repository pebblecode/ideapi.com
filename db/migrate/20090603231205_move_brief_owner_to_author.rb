class MoveBriefOwnerToAuthor < ActiveRecord::Migration
  def self.up
    rename_column :briefs, :user_id, :author_id
  end

  def self.down
    rename_column :briefs, :author_id, :user_id
  end
end
