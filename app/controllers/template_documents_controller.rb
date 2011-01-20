class TemplateDocumentsController < ApplicationController
  
  # needs login for all actions
  before_filter :require_user


  add_breadcrumb 'templates', :template_documents_path
  add_breadcrumb 'create a new template', :new_template_document_path, :only => [:new, :create] 

  def index
    @template_documents = TemplateDocument.owned_templates(current_account.id) # see named_scope in template_document.rb
  end 

  def new
    @template_document = TemplateDocument.new
    @template_document.template_questions.build
  end

 def show
    @template_document = TemplateDocument.find(params[:id], :include => :template_questions)
    add_breadcrumb @template_document.title, template_document_path(@template_document)
  end


  def create
    @template_document = TemplateDocument.new(params[:template_document])
    if @template_document.save
      flash[:notice] = "Successfully created template document"
      # Now that it has been saved correctly, connect it with current account
      @template_document.account_template_documents.new(:account => current_account).save
      redirect_to @template_document
    else
      render :action => 'new'
    end
  end
  
  def edit
    @template_document = TemplateDocument.find(params[:id])
    add_breadcrumb @template_document.title, template_document_path(@template_document)
    add_breadcrumb 'edit template'
    
  end
  
  def update
    @template_document = TemplateDocument.find(params[:id])
    if @template_document.update_attributes(params[:template_document])
      flash[:notice] = "Successfully updated template"
      redirect_to @template_document
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    
    @template_document = AccountTemplateDocument.find_by_account_id_and_template_document_id(current_account.id, params[:id])
    @template_document.destroy
    flash[:notice] = "Successfully destroyed template document"
    redirect_to template_documents_url
  end

  def sort
    order = params[:document_item]
    TemplateDocumentQuestion.order(order) # order method is in model
    render :nothing => true
  end

end
