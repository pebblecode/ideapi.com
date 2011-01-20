module Ideapi
  module Config
  
    def self.included(base)       
      base.extend ClassMethods    
    end
  
    module ClassMethods
      def has_document_config
        include InstanceMethods
      
        belongs_to :document_config
        before_validation :assign_document_config
      end
    end
  
    module InstanceMethods
      private
      
      def assign_document_config
        self.document_config = DocumentConfig.current if self.document_config.blank?
      end
    end
  
  end  
end