require 'test_helper'

class GeneralBriefAssumptions < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "general briefs on the website" do
    setup do
      @author = User.make(:password => "testing")
      @standard_user = User.make(:password => "testing")
      @published = Brief.make(:published, :user => @author)
      @draft = Brief.make
    end

    context "standard user" do
      setup do
        login_as(@standard_user)
      end

      context "when logged in" do

        setup do
          visit briefs_path
        end

        should_respond_with :success
        should_render_template :index

        should "be viewing briefs" do        
          assert_equal(briefs_path, path)
        end

        context "viewing a published brief" do
          setup do
            visit brief_path(@published)
          end

          should_respond_with :success
          should_render_template :show

          should "be viewing brief" do        
            assert_equal(brief_path(@published), path)
          end
        end

        context "viewing a draft brief" do
          setup do
            visit brief_path(@draft)
          end

          should_respond_with :success
          should_render_template :index

          should "be viewing brief" do        
            assert_equal(briefs_path, path)
          end
        end

      end

    end

    context "brief author" do
      setup do
        login_as(@author)
      end

      context "when logged in" do

        setup do
          visit briefs_path
        end

        should_respond_with :success
        should_render_template :index

        should "be viewing briefs" do        
          assert_equal(briefs_path, path)
        end

        context "viewing a draft brief that isnt their own" do
          setup do
            visit brief_path(@draft)
          end

          should_respond_with :success
          should_render_template :index

          should "be viewing brief" do        
            assert_equal(briefs_path, path)
          end
        end

      end  

    end

  end
  
end