class BriefConfig < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  
  has_many :briefs
  has_many :sections
  
  def self.current
    current = find(:first, :order => :created_at)
    raise 'Please have an admin create a BriefConfig before continuing' if current.blank?
    return current
  end
  
end
