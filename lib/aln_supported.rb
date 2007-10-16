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
    if sup.class.eql?(Array)
    else
    end
  end
  
  def loaded?
    @loaded
  end
  
  def load(supporter)
    @loaded = true
  end
  
end