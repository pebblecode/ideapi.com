require 'rubygems'
require 'active_support'
require 'active_support/test_case'

require 'action_view'
require 'totally_truncated'

class Boom

  include TotallyTruncated
  
  def explode
    "BOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOM"
  end

  def implode
    "PPPPPPUUUUUURRRRFFFFFFFFFFFFFFFFFFFFF"
  end

  def implode_then_explode
    implode + " THEN " +  explode
  end

  truncates :explode
  
  # options are the same as the truncate method exposed
  # in ActionView
  truncates :implode, :implode_then_explode, { :length => 20 }

end