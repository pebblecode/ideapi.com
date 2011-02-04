require 'test_helper'

class CreativeResponsesTest < ActionController::IntegrationTest
  include DocumentWorkflowHelper
  include ActionView::Helpers::TextHelper
  
  context "" do
    setup do
      should_have_template_document
      
      @account, @author = user_with_account
      @user = User.make(:password => "testing")
      
      @document = Document.make(:published, :author => @author, :account => @account)
      
      populate_document(@document)
    end

    context "as a collaborator viewing a document" do
      setup do
        @account.users << @user
        @document.users << @user

        login_to_account_as(@account, @user)
        visit document_path(@document)
      end

      should "have link to create a response" do
        assert_select 'a[href=?]', new_document_proposal_path(@document), 
          :text => 'Draft new idea'
      end
      
      context "creating a response" do
        setup do
          click_link 'Draft new idea'
        end

        should_respond_with :success

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
            should_render_template :edit
            should "should have one proposal" do
              assert_equal 1, Proposal.count
            end
            # should_change("the number of proposal", :by => 1) { Proposal.count }
            
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
         
        end
        
        
      end
                
      context "visiting document with draft response" do
        
        setup do
          @proposal = @user.proposals.make(:document => @document)
          visit document_path(@document)
        end
        
        should "be a draft" do
          assert @proposal.draft?
        end
        
        should "have link to existing response" do
          assert_select 'a[href=?]', document_proposal_path(@document, @proposal)
        end
        
      end
    
      context "editing draft response" do
        setup do
          @proposal = @user.proposals.make(:document => @document)
          visit edit_document_proposal_path(@document, @proposal)
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
            assert_equal(document_proposal_path(@document, @proposal), path)
          end

        end

        context "clicking save draft" do
          setup do
            @new_title = "Some other title"
            fill_in 'title', :with => @new_title
            click_button 'Save draft'
          end
        
          should_respond_with :success
        
          should "save any changes" do
            assert_equal(@new_title, @proposal.reload.title)
          end
        
          should "redirect to edit page" do
            assert_equal(edit_document_proposal_path(@document, @proposal), path)
          end
          
        end
        
        context "uploading asset" do
          setup do
            attach_file 'Upload file', File.join(Rails.root, 'test', 'fixtures', 'asset.jpg')
            click_button 'Save draft'
          end
        
          should "have an attachment" do
            assert @proposal.reload.assets.first.data.file?
          end
        
          should "match filename to fixture uploaded" do
            assert_equal(@proposal.reload.assets.first.data_file_name, "asset.jpg")
          end
        
          context "removing uploaded asset" do
        
            should "have a link to remove image" do
              assert_select 'a[href=?]', asset_path(@proposal.reload.assets.first), :text => 'Remove this!'
            end
        
            context "by clicking the link and accepting" do
              setup do
                reload
                click_link 'Remove this!'
              end
        
              should "have no attachment" do
                assert @proposal.reload.assets.empty?
              end
            end
        
          end
        
        end
        
        context "clicking publish" do
        
          setup do
            visit document_proposal_path(@document, @proposal)
            click_button 'Submit idea'
          end
        
          should_respond_with :success
          should_render_template :show
          
          should "change published count by one" do
            assert_equal 1, Proposal.published.count
          end
          
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
