class AddDefaultFlagToTemplateDocuments < ActiveRecord::Migration
  def self.up
    add_column :template_documents, :default, :boolean, :default => false
    
    if template = TemplateDocument.first
      template.default = true
      if template.save
        Account.all.each do |account|
          account.template_documents << template
        end 
      end
    end  
  end

  def self.down
    remove_column :template_documents, :default
  end
end
