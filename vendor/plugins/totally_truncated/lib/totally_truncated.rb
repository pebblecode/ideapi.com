module TotallyTruncated

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
  
    def truncates(*args)
      options = (args.extract_options!).reverse_merge(:length => 30)
      
      include ActionView::Helpers::TextHelper

      args.each do |attr_to_shorten|
        instance_eval do
          define_method("#{attr_to_shorten}_truncated", lambda { truncate(self.send(attr_to_shorten).to_s, options) })
        end
      end
    end

  end

end

# Set it all up.
if Object.const_defined?("ActiveRecord") && Object.const_defined?("ActionView")
  ActiveRecord::Base.send(:include, TotallyTruncated)
end
