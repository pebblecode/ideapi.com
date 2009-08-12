class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :recipient_email
      
      t.column :user_id, :integer
      t.column :code, :string
      
      t.column :redeemed_at, :datetime
      t.column :redeemed_by_id, :integer
      
      t.string :state
      
      t.references :redeemable, :polymorphic => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
