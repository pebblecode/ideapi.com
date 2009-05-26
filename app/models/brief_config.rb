class BriefConfig < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  
  has_many :briefs
  has_many :sections
  
  def self.current
    find(:first, :order => :created_at)
  end
  
end
