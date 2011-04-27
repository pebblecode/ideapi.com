class SubscriptionAdmin::AccountOwnersController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  
  before_filter :load_templates, :only => [:edit, :update]
  before_filter :build_template, :only => [:edit]
  before_filter :get_custom_query_descriptions
  before_filter :reject_unauthorized_hosts
  
  def index
    #@account_owners = ViewAccountOwner.find(:all)
    @users = User.find(:all)
  end
  
  def custom_query
    if params[:query_num]
      query_num = params[:query_num].to_i
      unless (query_num >= @custom_query_descriptions.count) or (query_num < 0)
        @query_description = @custom_query_descriptions[query_num]
        @users = nil
        
        # See @custom_query_descriptions
        case query_num
        when 0 
          # Users who have never logged in
          @users = User.find(:all, :conditions => ["last_login_at IS NULL"])
        when 1
          # Users who haven't logged in last month, with no documents
          @users = User.find_by_sql "SELECT u.email 
                                     FROM users AS u
                                     LEFT JOIN user_documents AS ud 
                                      ON u.id = ud.user_id 
                                     WHERE (u.last_login_at < (NOW() - INTERVAL 1 MONTH)) 
                                     GROUP BY u.id
                                      HAVING COUNT(ud.id) = 0"                                     
        when 2
          # Users who haven't logged in last month, with 1 or more documents
          @users = User.find_by_sql "SELECT u.email 
                                     FROM users AS u
                                     LEFT JOIN user_documents AS ud 
                                      ON u.id = ud.user_id 
                                     WHERE (u.last_login_at < (NOW() - INTERVAL 1 MONTH)) 
                                     GROUP BY u.id
                                      HAVING COUNT(ud.id) > 0" 
        when 3
          # Users who have logged in last month, with no documents
          @users = User.find_by_sql "SELECT u.email 
                                     FROM users AS u
                                     LEFT JOIN user_documents AS ud 
                                      ON u.id = ud.user_id 
                                     WHERE (u.last_login_at >= (NOW() - INTERVAL 1 MONTH)) 
                                     GROUP BY u.id
                                      HAVING COUNT(ud.id) = 0"
        when 4
          # Users who have logged in last month, with 1 or more documents
          @users = User.find_by_sql "SELECT u.email 
                                     FROM users AS u
                                     LEFT JOIN user_documents AS ud 
                                      ON u.id = ud.user_id 
                                     WHERE (u.last_login_at >= (NOW() - INTERVAL 1 MONTH)) 
                                     GROUP BY u.id
                                      HAVING COUNT(ud.id) > 0"          
        end
        
      else
        redirect_to :action => :index
      end
    else
      redirect_to :action => :index
    end    
  end
    
  def get_custom_query_descriptions
    @custom_query_descriptions = [
      "Users who have never logged in",
      "Users who haven't logged in last month, with no documents",
      "Users who haven't logged in last month, with 1 or more documents",
      "Users who have logged in last month, with no documents",
    	"Users who have logged in last month, with 1 or more documents"
    ]    
  end
  
end
