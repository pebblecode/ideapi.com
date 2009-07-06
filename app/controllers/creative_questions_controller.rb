class CreativeQuestionsController < ApplicationController
  make_resourceful do
    belongs_to :brief
    actions :all
  end
end
