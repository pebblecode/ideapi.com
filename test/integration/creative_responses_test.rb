require 'test_helper'

class CreativeResponsesTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include ActionView::Helpers::TextHelper

  context "" do
    setup do
      @author = User.make(:password => "testing")
      @user = User.make(:password => "testing")      
      @brief = Brief.make(:published, :user => @author)
      populate_brief(@brief)
      
      login_as(@user)
    end
    
    context "submitting a creative response" do
      setup do
        visit brief_path(@brief)
      end
            
      context "when viewing a brief" do
        should "have link to create a response" do
          assert_select 'a[href=?]', new_brief_proposal_path(@brief), 
            :text => 'Draft response'
        end
      
        context "clicking on create response link" do
          setup do
            click_link 'Draft response'
          end
          
          should_respond_with :success
          should_render_a_form
          
          should "have title" do
            assert_select 'input[type=text][name=?]', "proposal[title]"
          end
          
          should "have body" do
            assert_select 'textarea[name=?]', 'proposal[long_description]'
          end
          
          context "filling in basic requirements and clicking save draft" do
            setup do
              @proposal = Proposal.plan
              
              fill_in 'Title', :with => @proposal[:title]
              fill_in 'Your idea', :with => @proposal[:long_description]              
            end
            
            context "clicking save draft" do
              setup do
                click_button 'save draft'
              end
              
              should_respond_with :success
              should_render_template :edit
              should_change "Proposal.count", :by => 1
              
              should "contain title" do
                assert_select 'input[type=text][value=?]', @proposal[:title]
              end

              should "contain body" do
                assert_contain(@proposal[:long_description])
              end

              should "not be published" do
                assert assigns(:current_object).draft?
              end
              
            end
            
            context "clicking publish" do
              setup do
                click_button 'Submit proposal'
              end
              
              should_respond_with :success
              should_render_template :show
              should_change "Proposal.count", :by => 1
              
              should "contain title" do
                assert_contain(@proposal[:title])
              end

              should "contain body" do
                assert_contain(@proposal[:long_description])
              end

              should "be published" do
                assert assigns(:current_object).published?
              end
              
            end
            
            
          end
          
          
        end
        
      end
    
    end
    
  end

end
