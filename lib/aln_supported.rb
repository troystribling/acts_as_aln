####################################################################################
#### ALN Resource Supported container
####################################################################################
class AlnSupported

  ##################################################################################
  def initialize(supporter)
    @supporter = supporter
    @supported = []
    @loaded = false
  end
  
  ##################################################################################
  def [](index)
    @supported[index]
  end

  ##################################################################################
  def each
    @supported.each{|s| yield(s)}
  end
  
  ##################################################################################
  def << (sup)
    if sup.class.eql?(Array)
      sup.each{|s| s.supporter = @supporter}
    else
      sup.supporter = @supporter
      sup = [sup]
    end
    @supported + sup
  end
  
  ##################################################################################
  def loaded?
    @loaded
  end
  
  ##################################################################################
  def load
    unless loaded?
      @supported = @supporter.class.find_by_supporter_id(@supporter.id)
      @loaded = true
    end
    @supported.nil? ? [] : @supported
  end
  
end