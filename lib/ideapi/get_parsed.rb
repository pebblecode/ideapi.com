module Ideapi
  
  module GetParsed
    
    def self.included(base)
      base.extend ClassMethods    
    end
    
    module ClassMethods
    
      attr_accessor :gp_carriage_return_fields
      attr_accessor :gp_link_parse_fields
    
      def parse_carriage_returns_on(*args)
        @gp_carriage_return_fields = args
        
        include CarriageConvertor
        before_save :parse_carriage_returns
      end
      
      def parse_links_to_html_on(*args)
        @gp_link_parse_fields = args
        
        include LinkParser
        before_save :parse_all_links
      end
      
    end
    
    module LinkParser
      
      def parse_all_links
        self.class.gp_link_parse_fields.each do |m_attr|
          if self.send(m_attr).present?
            self.send("#{m_attr}=", parse_links(self.send(m_attr)))
          end
        end
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
      
    end
    
    module CarriageConvertor
      def parse_carriage_returns
        self.class.gp_carriage_return_fields.each do |m_attr|
          if self.send(m_attr).present?
            self[m_attr] = self.send(m_attr).gsub(/\n/, '<br />')          
          end
        end
      end
    end
    
  end

end