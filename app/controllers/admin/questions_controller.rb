class Admin::QuestionsController < Admin::BaseController  
  make_resourceful do
    actions :all
  end
end
