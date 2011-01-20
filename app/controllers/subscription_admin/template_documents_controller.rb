class SubscriptionAdmin::TemplateDocumentsController < ApplicationController
  before_filter :reject_unauthorized_hosts
  
  # include ModelControllerMethods
  include AdminControllerMethods
  
  helper_method :questions_available
  
  def current_objects
    @current_objects = TemplateDocument.paginate(:page => params[:page], :per_page => 30, :order => 'title')
  end

  def url_helper_prefix
    "admin_"
  end
  
  def sort
    @template = TemplateDocuments.find(params[:id])
    @template.template_questions.each do |question|
      question.position = params['template_questions'].index(question.id.to_s) + 1
      question.save
    end
    render :nothing => true
  end

  make_resourceful do
    actions :all
  
    response_for :show do |format|
      format.html { redirect_to :action => 'edit' }
    end
    
    before :edit do
      current_object.template_document_questions.build  
    end
    
  end

  private
  
  def questions_available
    @questions_available ||= TemplateQuestion.available_for_template(current_object)
  end

end
