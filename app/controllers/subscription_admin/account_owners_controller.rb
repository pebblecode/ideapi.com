class SubscriptionAdmin::AccountOwnersController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  
  before_filter :load_templates, :only => [:edit, :update]
  before_filter :build_template, :only => [:edit]
  before_filter :get_all_custom_queries
  before_filter :reject_unauthorized_hosts
  
  def index
    #@account_owners = ViewAccountOwner.find(:all)
    @users = User.find(:all)
  end
  
  def custom_query
    if params[:query_num]
      query_num = params[:query_num].to_i
      unless (query_num >= @custom_queries.count) or (query_num < 0)
        @query = @custom_queries[query_num]
      else
        redirect_to :action => :index
      end
    else
      redirect_to :action => :index
    end    
  end
    
  def get_all_custom_queries
    @custom_queries = [
      "Users where last_login = NULL",
      "Users where last_login &gt; 1 month ago AND #docs = 0",
    	"Users where last_login &gt; 1 month ago AND #docs > 0",
    	"Users where last_login &lt;= 1 month ago AND #docs = 0",
    	"Users where last_login &lt;= 1 month ago AND #docs > 0"
    ]    
  end
  
end
