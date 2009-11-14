require 'test_helper'

class AccountSignupTest < ActionController::IntegrationTest

  context "" do
    setup do
      
      @plans = returning({}) do |plans|
        %w(free basic premium).each do |plan_name|
          plans[plan_name.to_sym] = SubscriptionPlan.make(plan_name.to_sym)
        end
      end
      
    end

    context "creating an account" do
      setup do
        visit plans_path
      end
      
      should_respond_with :success

      context "signup form" do
        setup do
          @account = Account.plan(:plan => @plans[:free])
          @user = User.plan
                    
          fill_in 'Company', :with => @account[:name]
          fill_in 'Domain', :with => @account[:domain]
          fill_in 'First name', :with => @user[:first_name]
          fill_in 'Last name', :with => @user[:last_name]
          fill_in 'Screename', :with => @user[:login]
          fill_in 'Email', :with => @user[:email]
          fill_in 'Password', :with => @user[:password]
          fill_in 'Password confirmation', :with => @user[:password]
          
          choose "plan_#{@plans[:free].id}"
          
          click_button 'Create my account'
        end
      
        should_change "Account.count", :by => 1
        should_change "User.count", :by => 1
        
        should "not have any errors" do          
          assert_contain 'Account created'
        end
        
        context "created account" do
          setup do
            @created_account = Account.find_by_name(@account[:name])            
          end

          should "give a link to the account url" do
            assert_contain(@created_account.full_domain)
          end
          
          context "visting account" do
            setup do
              visit "http://" + @created_account.full_domain
            end
            
            should "present user with dashboard" do
              assert_equal(dashboard_path, path)
            end

          end
          
        end
      
      end

    end
    
    context "logging into an account" do
      
      setup do
        @user_password = "testing"
        @account = Account.make(:user => User.make(:password => @user_password))
        
        visit 'http://' + @account.full_domain
      end

      should "redirect to login page" do
        assert_equal(new_user_session_path, path)
      end
      
      context "as an account admin" do
        setup do
          fill_in 'Email', :with => @account.admin.email
          fill_in 'Password', :with => @user_password
          
          click_button 'Login'
        end

        should "take user to dashboard" do
          assert_equal(dashboard_path, path)
        end
        
        should "have an account link" do
          assert_select 'a[href=?]', account_path, :text => 'account', :count => 1
        end
        
        context "attempting to access account page" do
          setup do
            visit account_path
          end

          should "take user to account management" do
            assert_equal(account_path, path)
          end
        end
      end
      
      context "as an account user" do
        setup do
          @user = User.make(:password => @user_password)
          
          # add user to account
          @account.users << @user
          
          fill_in 'Email', :with => @user.email
          fill_in 'Password', :with => @user_password
          
          click_button 'Login'
        end

        should "take user to dashboard" do
          assert_equal(dashboard_path, path)
        end
        
        should "not have an account link" do
          assert_select 'a[href=?]', account_path, :text => 'account', :count => 0
        end
        
        context "attempting to access account page" do
          setup do
            visit account_path
          end

          should "redirect back to dashboard" do
            assert_equal(dashboard_path, path)
          end
        end
        
      end
      
      context "as someone who doesnt have access to an account" do
        setup do
          @invalid_user = User.make(:password => @user_password)
          
          fill_in 'Email', :with => @invalid_user.email
          fill_in 'Password', :with => @user_password
          
          click_button 'Login'
        end

        should "redirect back to login page" do
          assert_equal(new_user_session_path, path)
        end
      end
      
    end
      
    context "visiting account subdomain that doesnt exist" do
      
      setup do
        visit "http://stupidexample234.#{AppConfig['base_domain']}"
      end
      
      should "redirect to account not found" do
        assert_equal("/account_not_found", path)
      end
      
    end
  end
  
end