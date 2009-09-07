module Ideapi
  
  module HighSociety
    
    def self.included(base)
      base.extend(Invites::ClassMethods)
      base.send(:include, Invites::InstanceMethods)
    end
    
    module Invites
    
      module ClassMethods
      
        def max_invites
          @max_invites ||= 0
        end
      
        def initial_invite_count
          @init_invite_count ||= 0
        end
      
        def can_grant_invites_to_others(options = {})
          options.reverse_merge!({:initialise_with => 0, :max_invites => 10})
        
          @max_invites = options[:max_invites]
          @init_invite_count = options[:initialise_with]
        
          has_many :invitations, 
            :dependent => :destroy, 
            :before_add => [:ensure_has_invites], 
            :after_add => :decrement_invites, 
            :after_remove => :increment_invites
        end
      
      end
    
      module InstanceMethods
      
        def ensure_has_invites(invite)          
          if invite_count.zero? && !user_exists?(invite)
            raise 'NotEnoughInvites' 
          end
        end
      
        def decrement_invites(invite)
          if !user_exists?(invite)
            revoke_invites!(1)
          end            
        end
        
        def user_exists?(invite)
          return User.find_by_email(invite.recipient_email).present?
        end
      
        def increment_invites(invite = nil)
          grant_invites!(1)
        end
      
        def grant_invites(number = 0)
          self.invite_count += number
        end
      
        def revoke_invites(number = 0)
          self.invite_count -= number
        end
      
        def grant_invites!(number = 0)
          grant_invites(number)
          save
        end
      
        def revoke_invites!(number = 0)
          revoke_invites(number)
          save
        end
      
        def invite_count
          ensure_default_invite_count
          self[:invite_count]
        end
      
        def invite_count=(number)
          # ensure its positive
          number =  self.class.initial_invite_count if (number.blank? || number < 0)
        
          # ensure doesnt exceed max invite level
          number = self.class.max_invites if number > self.class.max_invites
        
          self[:invite_count] = number
        end
      
        def has_invites?
          !(self.invite_count.zero? && self.invitations.blank?)
        end
      
        def invite_cancelled(invite)
          increment_invites(1)
        end
      
        private
      
        def ensure_default_invite_count
          (self.invite_count = self.class.initial_invite_count) if self[:invite_count].blank?
        end
      
      end
    
    end
        
  end
  
end