class Author < User
  has_many :briefs
  
  delegate :draft, :to => :briefs
  delegate :published, :to => :briefs    
end
