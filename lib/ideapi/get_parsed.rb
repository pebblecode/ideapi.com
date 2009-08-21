module Ideapi
  
  module GetParsed
    
    def self.included(base)
      base.extend ClassMethods    
    end
    
    module ClassMethods
    
      attr_reader :gp_attrs_to_parse
    
      def gp_parse_fields(*args)
        @gp_attrs_to_parse = args
                
        include InstanceMethods
        before_save :parse_all_attributes
        
        gp_attrs_to_parse.each do |m_attr|
          define_parse_method_for(m_attr)
        end
      end
      
      def get_parsed_attr_name(original_attr)
        "#{original_attr}_parsed"
      end
      
      #private
      
      def define_parse_method_for(m_attr)
        instance_eval do
          parsed_m_attr = get_parsed_attr_name(m_attr)
          if !self.respond_to?(parsed_m_attr)
            define_method(parsed_m_attr, lambda { parse_string(self.send(m_attr).to_s) })
          end            
        end
      end
      
    end
    
    module InstanceMethods
      
      def parse_all_attributes
        self.class.gp_attrs_to_parse.each do |m_attr|
          parsed_m_attr = self.class.get_parsed_attr_name(m_attr)
          if self.respond_to?("#{parsed_m_attr}=") && self.send(m_attr).present?
            self.send("#{parsed_m_attr}=", parse_string( self.send(m_attr) ))    
          end
        end
      end
      
      def parse_string(str)
        line_breaks_into_br_tags( parse_links(str) )
      end
      
      def parse_links(str)
        urls = {}
        match_count = 0

        while(match = str.match(/(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?/ix)) do
          match_count += 1
          match_id = "FP_URLMATCH_#{match_count}_#{Time.now.to_i.to_s}"
          str.gsub!(match[0], match_id)
          urls[match_id] = match[0]
        end

        urls.each { |key, val| str.gsub!(/#{key}/, "<a href='#{val}' title='visit: #{val}'>#{val}</a>") }

        return str
      end
      
      def line_breaks_into_br_tags(str)
        str.gsub(/\n/, '<br />')
      end
      
    end
     
  end

end