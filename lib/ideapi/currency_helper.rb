module Ideapi
  module CurrencyHelper    
    
    include ActionView::Helpers::NumberHelper
    
    def number_to_currency_with_pound(amount, options = {})
      options.reverse_merge!({ :unit => '&pound;' })
      number_to_currency_without_pound(amount, options)
    end
    
    alias_method_chain :number_to_currency, :pound
    
  end
end