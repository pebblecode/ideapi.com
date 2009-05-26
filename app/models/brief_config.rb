class BriefConfig < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  
  has_many :briefs
  has_many :brief_sections
  
  def current
    find(:first, :order => :created_at)
  end
  
end
