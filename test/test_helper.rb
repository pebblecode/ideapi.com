ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require "authlogic/test_case"
require "webrat"

require 'machinist/active_record'
require 'sham'
require 'faker'

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
end

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

module BriefPopulator      
  def populate_template_brief
    @default_template_brief ||= TemplateBrief.make(:title => "default")

    rand(10).times do
      @default_template_brief.template_questions << TemplateQuestion.make
    end
    
    return @default_template_brief
  end
end

module BriefWorkflowHelper
  
  def brief_for(author)
    return Brief.make(:author => author)
  end
  
  def populate_brief(brief, n = 10)
    n.times do 
      BriefItem.make(:brief => brief)
    end
    brief.save
  end
  
  def check_for_questions(brief, creative)
    populate_brief(brief)
    
    5.times do
      brief.creative_questions.make(:answered, {:brief_item => brief.brief_items.first, :creative => creative, :author_answer => "Answered question"})
    end      
    
    visit brief_path(brief)
        
    assert !brief.brief_items.blank?          
    assert !brief.creative_questions.answered.blank?

    brief.creative_questions.answered.each do |q|
      assert_select 'ul.brief_item_history'
      assert_contain(q.body)
      assert_contain(q.author_answer)
    end
  end
  
end

class ActiveSupport::TestCase
  
  def login(user)
    activate_authlogic
    UserSession.create(user)
  end
  
  def login_as(user)
    visit new_user_session_path
    fill_in "login", :with => user.login
    fill_in "password", :with => "testing"
    click_button
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
          fill_in "login", :with => @user.login
          fill_in "password", :with => "testing"
          click_button
        end
        
        should_respond_with :success
        
        should "be showing the dashboard if logged in" do
          assert_equal(briefs_path, path)
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


