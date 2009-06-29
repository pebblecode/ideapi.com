class Site < ActiveRecord::Base
  has_many :briefs
  has_many :template_briefs
end
