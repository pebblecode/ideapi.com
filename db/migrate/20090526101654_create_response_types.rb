class CreateResponseTypes < ActiveRecord::Migration
  def self.up
    create_table :response_types do |t|
      t.string :title
      t.string :options
    end
  end

  def self.down
    drop_table :response_types
  end
end
