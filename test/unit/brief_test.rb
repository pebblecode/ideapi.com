require 'test_helper'

class BriefTest < ActiveSupport::TestCase
  
  fixtures :users

  context "Questions and Answer relationship" do
    setup do
      @brief = Brief.plan
    end

    should "have questions available from current config" do
      
    end
  end
  

end
