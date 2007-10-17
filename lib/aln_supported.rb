####################################################################################
#### ALN Resource Supported container
####################################################################################
class AlnSupported

  def initialize
    @supported = []
    @loaded = false
  end
  
  def [](index)
    @supported[index]
  end
  
  def << (sup)
    sup = [sup] unless sup.class.eql?(Array)
    @supported + sup
  end
  
  def loaded?
    @loaded
  end
  
  def load(supporter)
    @loaded = true
  end
  
end