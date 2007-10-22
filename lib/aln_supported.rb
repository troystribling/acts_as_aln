####################################################################################
#### ALN Resource Supported container
####################################################################################
class AlnSupported

  ##################################################################################
  def initialize(supporter)
    @supporter = supporter
    @supporter.save if @supporter.new_record?
    @supported = []
    @loaded = false
  end
  
#  ##################################################################################
#  def [](index)
#    @supported[index]
#  end
#
#  ##################################################################################
#  def delete(sup)
#    @supported.delete(sup)
#  end
#
#  ##################################################################################
#  def clear
#    @supported.clear
#  end
#
#  ##################################################################################
#  def each
#    @supported.each{|s| yield(s)}
#  end
  
  ##################################################################################
  def method_missing(meth, *args, &blk)
    begin
      super
    rescue NoMethodError
      @supported.send(meth, *args, &blk)
    end
  end

  ##################################################################################
  def count
    load.length
  end

  ##################################################################################
  def << (sup)
    if sup.class.eql?(Array)
      sup.each{|s| s.supporter = @supporter}
    else
      sup.supporter = @supporter
      sup = [sup]
    end
    @supported += sup
  end
  
  ##################################################################################
  def loaded?
    @loaded
  end
  
  ##################################################################################
  def load
    unless loaded?
      @supported = @supporter.class.find_all_by_supporter_id(@supporter.id)
      @loaded = true
    end
    self
  end
  
end