####################################################################################
#### ALN Resource Supporter container
####################################################################################
class AlnSupporter

  ##################################################################################
  def initialize(sup)
    @supported = sup
    @supporter = nil
    @loaded = false
  end
  
  ##################################################################################
  def method_missing(meth, *args, &blk)
    begin
      super
    rescue NoMethodError
      @supporter.send(meth, *args, &blk)
    end
  end

  ##################################################################################
  def loaded?
    @loaded
  end

  ##################################################################################
  def exists?
    not @supporter.nil?
  end

  ##################################################################################
  def id
    @supporter.nil? ? nil : @supporter.id
  end

  ##################################################################################
  def eql?(val)
    @supporter.eql?(val)
  end
  
  ##################################################################################
  def load
    unless loaded? or @supported.supporter_id.nil?
      @supporter = @supported.class.find(@supported.supporter_id)
      @loaded = true
    end
    self
  end
  
end