class BriefsController < ApplicationController
  
  before_filter :require_user
  # before_filter :require_author, :except => [:index, :show]
  # before_filter :require_owner, :except => [:index, :show]
  
  helper_method :current_brief_items
  
  def current_objects
    @current_objects ||= author? ? author_briefs : creative_briefs
  end
  
  def current_object
    @current_object ||= (  
      begin
        author? ? parent_object.briefs.find(params[:id]) : Brief.published.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        redirect_to briefs_path
      end
    )
  end
  
  make_resourceful do
    belongs_to :author, :creative
    actions :all
    
    before :create do
      current_object.template_brief = TemplateBrief.last
      current_object.author = parent_object
    end
    
    response_for(:index) do |format|
      # display a different view depending on the user type
      format.html { render :action => "index_#{user_type}" }
    end
    
    response_for(:show) do |format|
      format.html { 
        render :action => record_owner? ? "show_author" : "show"
      }
    end
  end
  
  def publish
    current_object.publish!
    respond_to do |format|
      format.html { redirect_to brief_path(current_object) }
    end
  end
  
  private
  
  # parent_object is standard make_resourceful accessor
  # overwrite with our current logged in user
  alias :parent_object :current_user
  
  # expose the briefs
  # check out lib/ideapi/expose_briefs.rb for the gory details
  include Ideapi::ExposeBriefs
  
  expose_briefs_as :author, :scope => [:draft, :published]
  expose_briefs_as :creative, :scope => [:watching, :pitching, :under_review, :complete]
  
  # only show answered items on a published brief
  def current_brief_items
    return [] if !current_object || !author?
    @current_brief_items ||= (current_object.published? ? send(:current_object).brief_items.answered : current_object.brief_items)
  end
  
  #override make_resouceful
  def user_type
    parent_object.class.to_s.downcase
  end
  
  def require_owner
    record_owner?
  end

  def record_owner?
    current_object.author == current_user 
  end

end
