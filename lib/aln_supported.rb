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
  def to_array
    @supported
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
  def load(*args)
    args[0].nil? ? force = false : force = args[0]
    unless loaded? and not force
      @supported = AlnResource.find_all_by_supporter_id(@supporter.id, :order => "support_hierarchy_left DESC")
      @loaded = true
    end
    self
  end
  
end