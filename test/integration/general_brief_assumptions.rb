require 'test_helper'

class GeneralBriefAssumptions < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "general briefs on the website" do
    setup do
      @published = Brief.make(:published)
      @draft = Brief.make
    end

    context "creative" do
      setup do
        @creative = Creative.make(:password => "testing")
        login_as(@creative)
      end

      should "be a creative" do
        assert assigns['current_user'].creative?
      end

      context "when logged in" do

        setup do
          visit briefs_path
        end

        should_respond_with :success
        should_render_template :index_creative

        should "be viewing briefs" do        
          assert_equal(briefs_path, path)
        end

        context "viewing a published brief" do
          setup do
            visit brief_path(@published)
          end

          should_respond_with :success
          should_render_template :show_creative

          should "be viewing brief" do        
            assert_equal(brief_path(@published), path)
          end
        end

        context "viewing a draft brief" do
          setup do
            visit brief_path(@draft)
          end

          should_respond_with :success
          should_render_template :index_creative

          should "be viewing brief" do        
            assert_equal(briefs_path, path)
          end
        end

      end  

    end

    context "author" do
      setup do
        @author = Author.make(:password => "testing")
        login_as(@author)
      end

      should "be a author" do
        assert assigns['current_user'].author?
      end

      context "when logged in" do

        setup do
          visit briefs_path
        end

        should_respond_with :success
        should_render_template :index_author

        should "be viewing briefs" do        
          assert_equal(briefs_path, path)
        end

        context "viewing a published brief that isnt their own" do
          setup do
            visit brief_path(@published)
          end

          should_respond_with :success
          should_render_template :show_creative

          should "be viewing brief" do        
            assert_equal(brief_path(@published), path)
          end
        end

        context "viewing a draft brief that isnt their own" do
          setup do
            visit brief_path(@draft)
          end

          should_respond_with :success
          should_render_template :index_author

          should "be viewing brief" do        
            assert_equal(briefs_path, path)
          end
        end

      end  

    end

  end
  
end