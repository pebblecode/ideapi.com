require 'test_helper'

class CreativeShowBrief < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
      
      @brief = Brief.make(:published)
      populate_brief(@brief)
    end
    
    context "viewing brief" do
      setup do
        visit brief_path(@brief)
      end

      should "see brief details" do
        assert_select 'h2', :text => @brief.title
        assert_contain(@brief.most_important_message)
      end
         
      context "answered questions" do
        setup do
          @author = @brief.author
          @creative = Creative.make
        end

        should "appear within the brief document" do          
          check_for_questions(@brief, @creative)
        end
      end 
      
      context "with ability to watch briefs" do
        should "have form to watch brief" do
          assert_select 'form[action=?][method=?]', watch_brief_path(@brief), 'post' do
            assert_select 'input[type=submit][value=?]', 'watch'
          end    
        end
        
        context "clicking the watch button" do
          setup do
            click_button 'watch'
          end
          
          should_respond_with :success
          
          should "be watching" do
            assert @creative.watching?(@brief)
          end
          
          should "toggle button to say stop watching" do
            assert_select 'input[type=submit][value=?]', 'watch', :count => 0
            assert_select 'input[type=submit][value=?]', 'stop watching'
          end
        end
        
        context "when watching a brief" do
          setup do
            @creative.watch(@brief)
            reload
          end

          should "show button as stop watching" do
            assert_select 'input[type=submit][value=?]', 'stop watching'
          end
          
          context "clicking the stop watching button" do
            setup do
              click_button 'stop watching'
            end

            should "not be watching anymore" do
              assert !@creative.watching?(@brief)
            end
            
            should "toggle button to say watching" do
              assert_select 'input[type=submit][value=?]', 'watch'
              assert_select 'input[type=submit][value=?]', 'stop watching', :count => 0
            end
          end
          
        end
        
      end
      
    
    end    
    
  end
end