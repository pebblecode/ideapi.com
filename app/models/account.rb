class Account < ActiveRecord::Base
  
  
  # Account subdomain name
  def subdomain
    full_domain.split('.').first
  end
  
  has_many :account_template_briefs
  has_many :template_briefs, :through => :account_template_briefs
  
  has_many :account_users, :dependent => :destroy
  
  has_many :users, :through => :account_users do    
    def admins
      all(:conditions => "account_users.admin = true")
    end
    
    def brief_authors
      all(:conditions => "account_users.can_create_briefs = true")
    end
  end
  
  accepts_nested_attributes_for :account_users, 
    :reject_if => proc { |attrs| attrs['author'] != '1'} 
    
  accepts_nested_attributes_for :account_template_briefs, 
    :allow_destroy => true
    
  authenticates_many :user_sessions
  
  has_many :briefs
  
  #has_one :admin, :class_name => "User", :conditions => { :admin => true }
  
  has_one :subscription, :dependent => :destroy
  has_many :subscription_payments
  
  class << self; attr_accessor :excluded_subdomains; end
  @excluded_subdomains =  %W( support blog www billing help api #{AppConfig['admin_subdomain']} )
  
  validates_format_of :domain, :with => /\A[a-zA-Z][a-zA-Z0-9]*\Z/
  validates_exclusion_of :domain, 
    :in => excluded_subdomains, 
    :message => "The domain <strong>{{value}}</strong> is not available."
  
  before_validation_on_create :activate_user
  
  validate :valid_domain?
  validate_on_create :valid_user?
  validate_on_create :valid_plan?
  validate_on_create :valid_payment_info?
  validate_on_create :valid_subscription?
  
  attr_accessible :name, :domain, :user, :plan, :plan_start, :creditcard, :address, :account_users_attributes, :account_template_briefs_attributes
  attr_accessor :user, :plan, :plan_start, :creditcard, :address, :affiliate
  
  after_create :create_admin
  after_create :send_welcome_email
  after_create :add_default_brief_template
  
  acts_as_paranoid
  
  Limits = {
    'user_limit' => Proc.new {|a| a.users.count },
    'brief_limit' => Proc.new {|a| a.briefs.count }
  }
  
  Limits.each do |name, meth|
    define_method("reached_#{name}?") do
      return false unless self.subscription
      self.subscription.send(name) && self.subscription.send(name) <= meth.call(self)
    end
    
    delegate name.to_sym, :to => :subscription
  end
  
  def needs_payment_info?
    if new_record?
      AppConfig['require_payment_info_for_trials'] && @plan && @plan.amount.to_f + @plan.setup_amount.to_f > 0
    else
      self.subscription.needs_payment_info?
    end
  end
  
  # Does the account qualify for a particular subscription plan
  # based on the plan's limits
  def qualifies_for?(plan)
    Subscription::Limits.keys.collect {|rule| rule.call(self, plan) }.all?
  end
  
  def active?
    self.subscription.next_renewal_at >= Time.now
  end
  
  def domain
    @domain ||= self.full_domain.blank? ? '' : self.full_domain.split('.').first
  end
  
  def domain=(domain)
    @domain = domain
    self.full_domain = "#{domain}.#{AppConfig['base_domain']}"
  end
  
  def to_s
    name.blank? ? full_domain : "#{name} (#{full_domain})"
  end
  
  delegate :admins, :to => :users
  delegate :brief_authors, :to => :users
  
  def admin
    self.users.admins.first
  end
  
  def admin?(a_user)
    self.users.admins.include?(a_user)
  end
 
  protected
  
    def valid_domain?
      conditions = new_record? ? ['full_domain = ?', self.full_domain] : ['full_domain = ? and id <> ?', self.full_domain, self.id]
      self.errors.add(:domain, 'is not available') if self.full_domain.blank? || self.class.count(:conditions => conditions) > 0
    end
    
    def activate_user
      @user.set_active if @user && @user.pending?
    end
    
    # An account must have an associated user to be the administrator
    def valid_user?
      if !@user
        errors.add_to_base("Missing user information")
      elsif !@user.valid?
        @user.errors.full_messages.each do |err|
          errors.add_to_base(err)
        end
      end
    end
    
    def valid_payment_info?
      if needs_payment_info?
        unless @creditcard && @creditcard.valid?
          errors.add_to_base("Invalid payment information")
        end
        
        unless @address && @address.valid?
          errors.add_to_base("Invalid address")
        end
      end
    end
    
    def valid_plan?
      errors.add_to_base("Invalid plan selected.") unless @plan
    end
    
    def valid_subscription?
      return if errors.any? # Don't bother with a subscription if there are errors already
      self.build_subscription(:plan => @plan, :next_renewal_at => @plan_start, :creditcard => @creditcard, :address => @address, :affiliate => @affiliate)
      if !subscription.valid?
        errors.add_to_base("Error with payment: #{subscription.errors.full_messages.to_sentence}")
        return false
      end
    end
    
    def create_admin
      account_users.create(:user => self.user, :admin => true, :can_create_briefs => true)
    end
    
    def send_welcome_email
      SubscriptionNotifier.deliver_welcome(self)
    end
    
    def add_default_brief_template
      self.template_briefs << TemplateBrief.default
    end
  
end
