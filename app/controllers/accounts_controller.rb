class AccountsController < ApplicationController
  include ModelControllerMethods
    
  skip_before_filter :account_required, :only => [ :new, :create, :plans, :cancelled, :thanks ]
  
  skip_before_filter :check_for_expired_account
  
  before_filter :admin_required, :except => [ :new, :create, :plans, :cancelled, :thanks ]
  
  before_filter :build_user, :only => [ :new, :create ]
  before_filter :load_subscription, :only => [ :show, :billing, :plan, :paypal, :plan_paypal, :update ]
  before_filter :load_plans, :only => [ :new, :create, :show, :update ]
  
  before_filter :load_billing, :only => [ :show, :new, :create, :billing, :paypal, :update ]
  before_filter :load_discount, :only => [ :show, :plans, :plan, :new, :create, :update ]
  before_filter :build_plan, :only => [:create]
  
  ssl_required :billing, :cancel, :new, :create
  ssl_allowed :plans, :thanks, :cancelled, :paypal
  
  add_breadcrumb 'account', '/account', :only => [:show]
  
  def new
    render :layout => 'signup'
  end
  
  def documents
    
  end
  
  
  def update
    @account = current_account
    if params[:delete_logo].present?
      params[:account][:logo] = nil
    end
    if @account.update_attributes(params[:account])
      flash[:notice] = "Successfully updated account"
      @account.reload
      if params[:account][:domain].present?
        redirect_to "http://#{@account.full_domain}/account" and return
      end
    else
      current_account.logo = Account.find(current_account.id).logo if current_account.logo.dirty? 
      flash[:error] = "Account could not be updated."
    end
    
    # if we changed the subdomain, we must redirect.
    
  
    
    if current_user != current_account.admin
      redirect_to '/documents'
    elsif params[:return_to].present?
      redirect_to params[:return_to]
    else
      render :action => 'show' and return
    end
    
  end
  
  def create
    @account.affiliate = SubscriptionAffiliate.find_by_token(cookies[:affiliate]) unless cookies[:affiliate].blank?
    
    @account.user.set_active

    if @account.needs_payment_info?
      @address.first_name = @creditcard.first_name
      @address.last_name = @creditcard.last_name
      @account.address = @address
      @account.creditcard = @creditcard
    end
    
    if @account.save
      flash[:domain] = @account.domain
      redirect_to :action => 'thanks'
    else
      render :action => 'new', :layout => 'signup' # Uncomment if your "public" site has a different layout than the one used for logged-in users
    end
  end

  def billing
    if request.post?
      @address.first_name = @creditcard.first_name
      @address.last_name = @creditcard.last_name
      
      if @creditcard.valid? & @address.valid?
        if @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
          flash[:notice] = "Your billing information has been updated."
        end
      end
            
    end
    
    #redirect_to :action => "show"
  end

  
  # Handle the redirect return from PayPal
  def paypal
    if params[:token]
      if @subscription.complete_paypal(params[:token])
        flash[:notice] = 'Your billing information has been updated'
        redirect_to :action => "billing"
      else
        render :action => 'billing'
      end
    else
      redirect_to :action => "billing"
    end
  end

  def plan
    if request.post?
      @subscription.plan = SubscriptionPlan.find(params[:plan_id])

      # PayPal subscriptions must get redirected to PayPal when
      # changing the plan because a new recurring profile needs
      # to be set up with the new charge amount.
      if @subscription.paypal?
        # Purge the existing payment profile if the selected plan is free
        if @subscription.amount == 0
          logger.info "FREE"
          if @subscription.purge_paypal
            logger.info "PAYPAL"
            flash[:notice] = "Your subscription has been changed."
            SubscriptionNotifier.deliver_plan_changed(@subscription)
          else
            flash[:error] = "Error deleting PayPal profile: #{@subscription.errors.full_messages.to_sentence}"
          end
          redirect_to :action => "show" and return
        else
          if redirect_url = @subscription.start_paypal(plan_paypal_account_url(:plan_id => params[:plan_id]), plan_account_url)
            redirect_to redirect_url and return
          else
            flash[:error] = @subscription.errors.full_messages.to_sentence
            redirect_to :action => "show" and return
          end
        end
      end
      
      if @subscription.save
        flash[:notice] = "Your subscription has been changed."
        SubscriptionNotifier.deliver_plan_changed(@subscription)
      else
        flash[:error] = "Error updating your plan: #{@subscription.errors.full_messages.to_sentence}"
      end
      redirect_to :action => "show"
    end
  end
  
  # Handle the redirect return from PayPal when changing plans
  def plan_paypal
    if params[:token]
      @subscription.plan = SubscriptionPlan.find(params[:plan_id])
      if @subscription.complete_paypal(params[:token])
        flash[:notice] = "Your subscription has been changed."
        SubscriptionNotifier.deliver_plan_changed(@subscription)
        redirect_to :action => "plan"
      else
        flash[:error] = "Error completing PayPal profile: #{@subscription.errors.full_messages.to_sentence}"
        redirect_to :action => "plan"
      end
    else
      redirect_to :action => "plan"
    end
  end
  
  def cancelled
    render :layout => 'landing'
  end

  def cancel
    if request.post?
      if params[:confirm].present?
        current_account.destroy
        current_user_session.destroy
        redirect_to :action => "cancelled"
      else
        flash[:error] = "You need to agree to cancelling your account, tick the box below and try again."
      end
    end
  end
  
  def thanks
    redirect_to :action => "plans" and return unless flash[:domain]
    render :layout => 'landing' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end

  protected
  
    def load_object
      @obj = @account = current_account
    end
    
    def build_user
      @account.user = @user = User.new(params[:user])
    end
    
    def build_plan
      redirect_to :action => "new" unless @plan = SubscriptionPlan.find(params[:plan])
      @plan.discount = @discount
      @account.plan = @plan
    end
    
    def redirect_url
      { :action => 'show' }
    end
    
    def load_billing
      @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
      @address = SubscriptionAddress.new(params[:address])
    end

    def load_subscription
      @subscription = current_account.subscription
    end
    
    # Load the discount by code, but not if it's not available
    def load_discount
      if params[:discount].blank? || !(@discount = SubscriptionDiscount.find_by_code(params[:discount])) || !@discount.available?
        @discount = nil
      end
    end
    
    def load_plans
      @plans = SubscriptionPlan.find(:all, :order => 'amount desc').collect {|p| p.discount = @discount; p }
      @freeplan = SubscriptionPlan.find(:first, :conditions => "name = 'Free'")
    end
    
    
    def admin_required
      unless admin?
        flash[:error] = "You don't have access to that .."
        redirect_to documents_path and return
      end
    end
    
    def authorized?
      %w(new create plans cancelled thanks).include?(self.action_name) || 
      (self.action_name == 'documents' && logged_in?) ||
      admin?
    end
    
end
