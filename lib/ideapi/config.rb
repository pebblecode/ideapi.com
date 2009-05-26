module Ideapi
  module Config
  
    def self.included(base)       
      base.extend ClassMethods    
    end
  
    module ClassMethods
      def has_brief_config
        include InstanceMethods
      
        belongs_to :brief_config
        before_validation :assign_brief_config
      end
    end
  
    module InstanceMethods
      private
      
      def assign_brief_config
        self.brief_config = BriefConfig.current if self.brief_config.blank?
      end
    end
  
  end  
end