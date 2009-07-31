#
# utility class to wrap an ordered hash .. 
# used in user.rb to wrap differed brief
# perspectives into a nice collection ..

# o_hash = Brief.all.group_by(&label) #=> #<OrderedHash {:watching=>[#<object>, #<object>], :pitching=>[#<object>, #<object>]}>
#
# collection = BriefCollection.new(o_hash)
# collection.count #=> 4
# collection[:watching] #=> [#<object>, #<object>]
#
class BriefCollection
  
  def initialize(ordered_hash = {})
    @ordered_hash = ordered_hash
  end
  
  def populate(ordered_hash)
    @ordered_hash = ordered_hash
  end
  
  def count
    @ordered_hash.sum {|key, briefs| briefs.size }
  end
  
  protected

  def method_missing(method, *args, &block)
    if @ordered_hash.respond_to?(method)
      @ordered_hash.send(method, *args, &block)
    else
      super
    end
  end
  
end