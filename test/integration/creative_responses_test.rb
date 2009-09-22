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
            
            context "" do
              setup do
                click_button 'save draft'
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

  
    context "visiting brief with draft response" do
      
      setup do
        @proposal = @user.proposals.make(:brief => @brief)
        visit brief_path(@brief)
      end
      
      should "be a draft" do
        assert @proposal.draft?
      end
      
      context "response button" do
        should "have link to existing response" do
          assert_select 'a[href=?]', edit_brief_proposal_path(@brief, @proposal), 
            :text => 'Edit your response'
        end
      
        context "clicking edit" do
          setup do
            click_link 'Edit your response'
          end

          should_respond_with :success
          should_render_a_form
          should_render_template :edit

        end
        
      
      end
      
      
    end
  
    
    context "editing draft response" do
      setup do
        @proposal = @user.proposals.make(:brief => @brief)
        visit edit_brief_proposal_path(@brief, @proposal)
      end

      context "clicking preview" do
        setup do
          @new_title = "Some other title"
          fill_in 'title', :with => @new_title
          click_button 'Preview'
        end

        should "save any changes" do
          assert_equal(@new_title, @proposal.reload.title)
        end
        
        should_respond_with :success
        
        should "redirect to show page" do
          assert_equal(brief_proposal_path(@brief, @proposal), path)
        end
        
      end
      
      context "clicking save draft" do
        setup do
          click_button 'Save draft'
        end
        
        should_respond_with :success
        
        should "redirect to show page" do
          assert_equal(brief_proposal_path(@brief, @proposal), path)
        end
      end


      context "uploading asset" do
        setup do
          attach_file 'attachment', File.join(Rails.root, 'test', 'fixtures', 'asset.jpg')
          click_button 'Save draft'
        end

        should "have an attachment" do
          assert @proposal.reload.attachment.file?
        end
        
        should "match filename to fixture uploaded" do
          assert_equal(@proposal.reload.attachment_file_name, "asset.jpg")
        end
        
        context "removing uploaded asset" do
          
          setup do
            visit edit_brief_proposal_path(@brief, @proposal)
          end
          
          should "have checkbox to remove image" do
            assert_select 'input#remove_image'
          end
          
          context "by clicking checkbox and submitting" do
            setup do
              reload
              check 'remove_image'
              click_button 'Save draft'
            end

            should "have no attachment" do
              assert !@proposal.reload.attachment.file?
            end
          end
          
        end
                
      end

    end
    
    
    context "dashboard" do
      setup do
        @user.watch(@brief)
        visit briefs_path
      end

      should "list brief in watching list" do
        assert_select '.watching li.brief', :text => @brief.title, :count => 1
      end
      
      should "not list brief in pitching list" do
        assert_select '.pitching li.brief', :count => 0
      end
      
      context "when pitching" do
        setup do
          @proposal = @user.proposals.make(:published, {:brief => @brief})
          reload
        end

        should "not list brief in watching list" do
          assert_select '.watching li.brief', :count => 0
        end

        should "list brief in pitching list" do
          assert_select '.pitching li.brief', :count => 1
        end
      end
        
    end
  
  end

end
