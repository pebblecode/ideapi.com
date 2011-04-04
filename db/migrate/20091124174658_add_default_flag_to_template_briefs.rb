class AddDefaultFlagToTemplateBriefs < ActiveRecord::Migration
  def self.up
    add_column :template_briefs, :default, :boolean, :default => false
    
    if template = TemplateBrief.first
      template.default = true
      if template.save
        Account.all.each do |account|
          account.template_briefs << template
        end 
      end
    end  
  end

  def self.down
    remove_column :template_briefs, :default
  end
end
