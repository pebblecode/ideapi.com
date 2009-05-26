# SimpleOrdering
module SimpleOrdering
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def has_simple_ordering
      #send :include, InstanceMethods
      send :extend, OrderMethods
    end
  end
  
  module OrderMethods
    def order!(*sorted_ids)
      transaction do
        sorted_ids.flatten.each_with_index do |id, pos|
          find(id).update_attributes(:position => (pos + 1)) if find(id)
        end
      end
    end
  end

  module InstanceMethods
  end
end