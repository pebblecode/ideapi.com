class TemplateBriefsController < ApplicationController
  
  # needs login for all actions
  before_filter :require_user



  add_breadcrumb 'dashboard', "/dashboard"
  add_breadcrumb 'create a new template', :new_template_brief_path, :only => [:new, :create] 
  



  def index
    @template_briefs = TemplateBrief.owned_templates(current_account.id) # see named_scope in template_brief.rb
  end 

  def new
    @template_brief = TemplateBrief.new
  end

 def show
    @template_brief = TemplateBrief.find(params[:id])
    add_breadcrumb @template_brief.title, template_brief_path(@template_brief)
  end


  def create
    @template_brief = TemplateBrief.new(params[:template_brief])
    @template_brief.account_template_briefs << AccountTemplateBrief.new(:account_id => current_account.id, :template_brief_id => @template_brief)
    if @template_brief.save
      flash[:notice] = "Successfully created template brief"
      redirect_to @template_brief
    else
      render :action => 'new'
    end
  end
  
  def edit
    @template_brief = TemplateBrief.find(params[:id])
  end
  
  def update
    @template_brief = TemplateBrief.find(params[:id])
    if @template_brief.update_attributes(params[:template_brief])
      flash[:notice] = "Successfully updated template"
      redirect_to @template_brief
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @template_brief = TemplateBrief.find(params[:id])
    @template_brief.destroy
    flash[:notice] = "Successfully destroyed template brief"
    redirect_to template_briefs_url
  end

  def sort
    order = params[:brief_item]
    TemplateBriefQuestion.order(order) # order method is in model
    render :nothing => true
  end



end