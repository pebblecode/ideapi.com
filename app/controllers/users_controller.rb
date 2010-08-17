class UsersController < ApplicationController
  
  add_breadcrumb 'profile', :object_path, :only => [:show]
  
  before_filter :require_no_user, :only => :signup
  before_filter :require_user, :except => [:signup, :update]
  before_filter :require_user_unless_pending, :only => :update
  
  before_filter :check_user_limit, :only => :create
  before_filter :require_record_owner, :only => [:edit, :update, :destroy]
  
  before_filter :account_admin_required, :except => [:signup, :update, :index, :show, :edit, :update]
  
  def current_object
    @current_object ||= (params[:id].blank?) ? current_user : User.find_by_screename(params[:id])
  end
  
  def current_objects
    @current_objects ||= current_account.account_users(:include => :user)
  end
  
  make_resourceful do      
    response_for :create do |format|
      format.html { redirect_to users_path }
    end
    
    actions :all

    before :new do
      current_account.briefs.active.ordered("title ASC").each do |b|
        current_object.user_briefs.build(:brief => b, :user => current_object)
      end
    end 
    
    before :create do
      current_object.invited_by = current_user
    end
    
    after :create do
      unless current_account.users.include?(current_object)
        current_account.users << current_object
        if params[:user][:can_create_briefs] == "1"
          assign_can_create_briefs(current_account, current_object)
        end
      end
      if current_object.pending?
        NotificationMailer.deliver_user_invited_to_account(current_object, current_account)
        flash[:notice] = "We've sent an invitiaton to " + current_object.email
      end
    end
        
  end
  
  
  def send_invite
    # need a user id. 
    
    if params[:id]
      @user = User.find(:first, :conditions => {:id => params[:id]})
      if @user.present? and @user.deliver_invite_code!(current_account)
        flash[:notice] = "Good! We've sent the invite code to the user."
      else
        flash[:notice] = "Sorry, there was a problem sending the invite code :-("
      end
    end
    redirect_to :action => :index
  end
  
  def signup
    if @current_object = current_account.users.pending.find_by_invite_code(params[:invite_code])
      if request.put?
        current_object.attributes = params[:user]
        current_object.activate!
        if current_object.save
          if @user_session = attempt_signin(current_object)
            redirect_back_or_default '/'
          end
        end  
      end
    else
      not_found
    end
  end
 
  private
  
  # This method allows a user to be assigned to account with
  # permissions to create a brief
  def assign_can_create_briefs(account, user)
    if current_account.admins.include?(current_user)
      a = AccountUser.find_by_account_id_and_user_id(account, user)
      a.can_create_briefs  = 1
      a.save!
    end
  end

  def build_object
    @current_object = current_model.find_or_initialize_by_email(object_parameters)  
  end
  
  def require_record_owner
    not_found unless current_object == current_user
  end
  
  def check_user_limit
    if current_account.reached_user_limit?
      flash[:error] = "The user that invited you needs to upgrade their account to add you, please contact them and try again."
      redirect_to '/'
    end
  end
  
  def require_user_unless_pending
    require_user unless current_object.pending?
  end
 
end
