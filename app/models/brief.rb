class Brief < ActiveRecord::Base
  belongs_to :brief_config
  belongs_to :user
  
  has_many :answers
  has_many :creative_responses
    
  before_validation :assign_brief_config
  
  validates_presence_of :user, :brief_config
  
  private 
  
  def assign_brief_config
    self.brief_config = BriefConfig.current if self.brief_config.blank?
  end
  
end
