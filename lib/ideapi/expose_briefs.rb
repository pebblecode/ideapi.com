# warning this module is very coupled .. its brittle as glass
# 
# why? Well its just to clean up the controller of loads of duplication
# so get over it and accept it as a extension not an abstraction
#
module Ideapi
  module ExposeBriefs
  
    def self.included(base)       
      base.extend ClassMethods    
    end
  
    module ClassMethods
      def expose_briefs_as(model, options = {})
        options.reverse_merge! :scope => []        
        # check for the model accessor
        if defined?(:parent_object)
          
          # define a method called scope
          class_eval do
            
            options[:scope].each do |scope|
              # I'm assuming author? creative? etc are setup ..
              # also that the parent object (author / creative)
              # delegate their methods appropriately .. draft published etc
              
              # I've done this because the creative brief methods are AR associations
              # so it allows a bit more flexiblity for the interface...
              define_method(scope.to_s, lambda { send("#{model}?") ? parent_object.send(scope) : [] })                
          
              # expose the method as a helper_method
              send(:helper_method, scope.to_sym)              
            end            
            
            # this basically creates a method called "author_briefs" or "creative_briefs"
            # then collects the results of all the above defined methods
            # so it is essentially doing the same as ..
            
            #   def author_briefs
            #     drafts + published
            #   end
          
            define_method("#{model}_briefs") { options[:scope].map { |scope| send(scope) }.flatten }  
          end

          # boom.
          
        else
          raise 'current_object should be defined - ie use make_resourceful'
        end
        
      end
    end
  
  end  
end