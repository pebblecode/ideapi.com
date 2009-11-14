class User < ActiveRecord::Base

  class << self

    def emails_from_string(str)
      str.split(/,|\s/).reject {|email| email.blank? || !valid_email?(email) }
    end  
    
    def email_regex
      @email_regex ||= /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    end
          
    def valid_email?(email)
      (email =~ email_regex ? true : false)
    end
  
    def stub(args)
      new(args.reverse_merge(:password => generate_password))
    end
    
    def generate_password
      
    end
    
  end

end