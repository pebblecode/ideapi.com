class CreateCreativeProposals < ActiveRecord::Migration
  def self.up
    create_table :creative_proposals do |t|
      t.text :short_description
      t.text :long_description
      t.integer :brief_id
      t.integer :creative_id

      t.timestamps
    end
  end

  def self.down
    drop_table :creative_proposals
  end
end
