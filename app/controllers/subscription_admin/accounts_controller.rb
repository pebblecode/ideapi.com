class SubscriptionAdmin::AccountsController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  
  before_filter :load_templates, :only => [:edit, :update]
  before_filter :build_template, :only => [:edit]
  before_filter :reject_unauthorized_hosts
  
  def index
    @accounts = Account.paginate(:include => :subscription, :page => params[:page], :per_page => 30, :order => 'accounts.name')
  end
  
  def show
    redirect_to :action => 'edit'
  end
  
  def edit
    
  end
  
  private
  
  def load_templates
    @available_templates ||= TemplateDocument.available_for_account(@account)
  end
  
  def build_template
    @account.account_template_documents.build
  end
  
end
