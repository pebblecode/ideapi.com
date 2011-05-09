ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'test/unit'
require "authlogic/test_case"
require "webrat"

require 'machinist/active_record'
require 'sham'
require 'faker'
I18n.reload!

require File.expand_path(File.dirname(__FILE__) + "/blueprints")

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all
  
  # Add more helper methods to be used by all tests here...  
  setup { Sham.reset }

  def should_have_template_document
    @template_document = TemplateDocument.make(:default => true)
    assert_equal(@template_document, TemplateDocument.default)    
  end
end

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

module DocumentPopulator      
  def populate_template_document
    @default_template_document ||= TemplateDocument.make(:title => "default", :default => true)

    rand(10).times do
      @default_template_document.template_questions << TemplateQuestion.make
    end
    
    return @default_template_document
  end
end

module DocumentWorkflowHelper
  
  def document_for(author)
    return Document.make(:author => author)
  end
  
  def populate_document(document, n = 10)
    n.times do 
      DocumentItem.make(:document => document)
    end
    document.reload
  end
  
  def check_for_questions(document, creative)
    populate_document(document)
    
    5.times do
      document.questions.make(:answered, {:document_item => document.document_items.first, :creative => creative, :author_answer => "Answered question"})
    end      
    
    visit document_path(document)
        
    assert !document.document_items.blank?          
    assert !document.questions.answered.blank?

    document.questions.answered.each do |q|
      assert_select 'ul.document_item_history'
      assert_contain(q.body)
      assert_contain(q.author_answer)
    end
  end
  
end

class ActiveSupport::TestCase
  
  def login(user)
    activate_authlogic
    @user_session = UserSession.create(user)
      
    return @user_session
  end
  
  def logout
    click_link 'logout'
    assert_equal(delete_user_session_path, path)
    click_button 'yes log me out'
    assert_equal(new_user_session_path, path)
  end
  
  # to be used with webrat
  def login_as(user)
    visit new_user_session_path
    
    assert_equal(new_user_session_path, path)
    
    fill_in "email", :with => user.email
    fill_in "password", :with => "testing"
    click_button
    assert_true(redirect?)        
    follow_redirect!
  end
  
  def login_to_account_as(account, user)
    visit "http://" + @account.full_domain
    
    login_as(user)
  end
  
  def user_with_account(password = "testing")
    user = User.make(:password => password)
    account = Account.make(:user => user)
    
    return account, user
  end
  
  def self.should_log_in_as(user, password = "testing")
    
    context "logging a user in" do
      setup do
        @user = instance_eval("@#{user}")
        visit new_user_session_path
      end
      
      should_respond_with :success
      
      context "filling in the login form" do
        setup do
          fill_in "email", :with => @user.email
          fill_in "password", :with => "testing"
          click_button
        end
        
        should_respond_with :success
        
        should "be showing the documents if logged in" do
          assert_equal(documents_path, path)
        end
        
      end
    
    end

  end
  
  # http://giantrobots.thoughtbot.com/2008/6/3/testing-paperclip-with-shoulda
  def self.should_have_attached_file(attachment)
    klass = self.name.gsub(/Test$/, '').constantize

    context "To support a paperclip attachment named #{attachment}, #{klass}" do
      should_have_db_column("#{attachment}_file_name",    :type => :string)
      should_have_db_column("#{attachment}_content_type", :type => :string)
      should_have_db_column("#{attachment}_file_size",    :type => :integer)
    end

    should "have a paperclip attachment named ##{attachment}" do
      assert klass.new.respond_to?(attachment.to_sym), 
             "@#{klass.name.underscore} doesn't have a paperclip field named #{attachment}"
      assert_equal Paperclip::Attachment, klass.new.send(attachment.to_sym).class
    end
  end

end


