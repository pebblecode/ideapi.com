class RenameDefaultTemplate < ActiveRecord::Migration
  def self.up
    execute 'update template_documents set title="Blank" where id=1'
  end

  def self.down
  end
end
