class BriefsController < ApplicationController
  
  before_filter :require_user
  
  make_resourceful do
    belongs_to :author, :creative
    actions :all
  end
  
  private
  
  def parent_object
    current_user
  end

end
