require 'test_helper'

class AccountSignupTest < ActionController::IntegrationTest

  context "" do
    setup do
      should_have_template_brief
      
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
          fill_in 'Screename', :with => @user[:screename]
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
        
        should "send out account signup email" do
          assert_sent_email do |email|
            email.subject == "Welcome to #{AppConfig['app_name']}!"
          end
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
            
            should "redirect to dashboard" do
              assert_equal(dashboard_path, path)
            end
            
            context "account owner" do
              setup do
                @user = @created_account.admin
              end

              should "be active" do
                assert(@user.active?, "Account owner should be activated when creating account.")
              end
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
  
    context "signing up for an account with existing credentials" do
      setup do
        visit plans_path
        
        @existing_user = User.make(:active)
        @existing_account = Account.make(:user => @existing_user)
        
        @account = Account.plan(:plan => @plans[:free])
        @user = User.plan
                  
        fill_in 'Company', :with => @account[:name]
        fill_in 'Domain', :with => @account[:domain]
        fill_in 'First name', :with => @user[:first_name]
        fill_in 'Last name', :with => @user[:last_name]
        fill_in 'Email', :with => @user[:email]
        fill_in 'Screename', :with => @user[:screename]
        fill_in 'Password', :with => @user[:password]
        fill_in 'Password confirmation', :with => @user[:password]
        
        choose "plan_#{@plans[:free].id}"
      end

      context "signup up with existing domain" do
        setup do
          fill_in 'Domain', :with => @existing_account.domain
          click_button 'Create my account'
        end
                
        should_not_change("Account count") { Account.count }
        
        should "have errors" do
          assert_contain("Domain is not available")
        end
        
      end
      
      context "signup up without screename" do
        setup do
          fill_in 'Screename', :with => ""
          click_button 'Create my account'
        end
        
        should "have the raise error telling user screename is needed" do
          # https://abutcher.lighthouseapp.com/projects/32755/tickets/46-bug-new-account-validation-error
          assert_select '.errorExplanation li', 
            :text => 'Screename must be a single combination of letters (numbers and underscores also allowed)', 
            :count => 1
        end
      end
      
      context "signup up with existing user" do
          
        context "email" do
          setup do
            fill_in 'Email', :with => @existing_user[:email]
            click_button 'Create my account'
          end
          
          should_not_change("Account count") { Account.count }
        
          should "have the correct error message displayed only once" do
            # https://abutcher.lighthouseapp.com/projects/32755/tickets/46-bug-new-account-validation-error
            assert_select '.errorExplanation li', :text => 'Email has already been taken', :count => 1
          end
          
          should "not have extra email error message" do
            # https://abutcher.lighthouseapp.com/projects/32755/tickets/46-bug-new-account-validation-error
            assert_select '.errorExplanation li', :text => 'Email already taken', :count => 0
          end
        end    
        
      end
      
    end
    
  
  end
  
end