require 'test_helper'

class BriefTest < ActiveSupport::TestCase
  include BriefPopulator

  should_belong_to :user
  should_belong_to :template_brief
  
  should_have_many :brief_items
  should_have_many :questions
  
  should_validate_presence_of :user_id, :title
  
  should_have_instance_methods :most_important_message
    
  context "with a user" do
    setup do
      User.delete_all
      @user = User.make(:password => "testing")
    end
    
    context "generate brief items from template" do
      setup do
        @template = populate_template_brief
        @brief = Brief.make(:template_brief => @template, :user => @user)
      end

      should "have brief items generated" do
        assert(!@brief.brief_items.empty?)
      end

      should "generate number of brief_items in line for each question" do
        assert_equal(@template.template_questions.count, @brief.brief_items.count)
      end
    end

    context "state machine" do
      setup do
        @brief = Brief.make(:user => @user)
      end

      should "start with draft state" do
        assert_equal(:draft, @brief.state)
      end

      should "be able to be published" do
        assert(@brief.respond_to?(:publish!), "Should respond to publish!")
      end

      context "publishing" do
        setup do
          @brief.publish!
        end

        should "be published" do
          assert_equal(:published, @brief.state)
        end

        should "respond to complete!" do
          assert @brief.respond_to?(:complete!)
        end

        should "be able to be complete" do
          @brief.complete!
          assert_equal(:complete, @brief.state)
        end

        should "respond to review!" do
          assert @brief.respond_to?(:review!)
        end

        context "peer review" do
          setup do
            @brief.review!
          end

          should "be able to put into review" do
            assert_equal(:under_review, @brief.state)
          end

          should "be able to be completed" do
            @brief.complete!
            assert_equal(:complete, @brief.state)
          end
        end

        context "complete" do
          setup do
            @brief.complete!
          end

          should "be complete" do
            assert_equal(:complete, @brief.state)
          end

          should "be able to archive" do
            @brief.archive!
            assert_equal(:archived, @brief.state)
          end
        end


      end

       context "persistance" do
         setup do
           @brief.publish!
         end

         should "be published when reloaded" do
           assert_equal(:published, @brief.state)
           @brief.reload
           assert_equal(:published, @brief.state)
         end
       end

    end
    
  end  
  
end
