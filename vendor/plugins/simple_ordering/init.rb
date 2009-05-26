# Include hook code here
require 'simple_ordering'

ActiveRecord::Base.class_eval do
  include SimpleOrdering
end