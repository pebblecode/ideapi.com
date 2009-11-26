class AddDefaultFlagToTemplateBriefs < ActiveRecord::Migration
  def self.up
    add_column :template_briefs, :default, :boolean, :default => false
    
    TemplateBrief.first.update_attribute(:default, true)
    
    template = TemplateBrief.first
    
    Account.all.each do |account|
      account.template_briefs << template
    end
  end

  def self.down
    remove_column :template_briefs, :default
  end
end
