module Ideapi
  module Schizo

    def self.included(base)             
      base.send(:include, AlterEgo)
      base.send(:include, InstanceMethods)
    
      base.extend(ClassMethods)  
    end
  
    module ClassMethods
      
      # call this method after
      # you have defined your states
      # in the class to get some tasty
      # helper methods ..
      
      def become_schizophrenic
        class_eval do
          states.each do |state_name, state|
            # create a named scope for all the defined scopes
            named_scope state_name, :conditions => ["state = ?", state_name.to_s]

            # create a state_name? instance method for each state ..
            # for example @brief.draft? => true
            define_method("#{state_name}?", lambda { self.state == state_name }) 
          end
        end
      end

    end
  
    module InstanceMethods
      
      attr_accessor :previous_state
      
      def stored_transition_to(state)
        @previous_state = self.state
        transition_to(state)
        save!
      end
      
      def ensure_default_state
         (self.state = self.class.default_state) if read_attribute(:state).blank?
      end
      
      # overwrite accessors so we can save to the database
      def state=(transition_to)
        write_attribute(:state, transition_to.to_s)
      end

      def state
        ensure_default_state
        read_attribute(:state).to_sym
      end
            
    end
  
  end  
end
