class AddLogLevelToTimelineEvents < ActiveRecord::Migration
  def self.up
    add_column :timeline_events, :log_level, :integer, :default => 1
  end

  def self.down
    remove_column :timeline_events, :log_level
  end
end
