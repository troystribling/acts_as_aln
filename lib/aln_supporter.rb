####################################################################################
#### ALN Resource Supporter container
####################################################################################
class AlnSupporter

  ##################################################################################
  def initialize(*args)
    @supported = args[0]
    args[1].nil? ? @supporter_id = "supporter_id=" : @supporter_id = args[1].to_s + "="
    @supporter = nil
    @loaded = false
  end
  
  ##################################################################################
  def value=(s)
    @supporter = s
    @supporter.save if @supporter.new_record?
    @supported.send(@supporter_id.to_sym, @supporter.id)
    @loaded = true
  end

  ##################################################################################
  def value
    @supporter
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
  def load?
    @supported.supporter_id.nil? ? false : @loaded
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
  def load(*args)
    args[0].nil? ? force = false : force = args[0]
    unless self.load? and not force
      @supporter = AlnResource.find(@supported.supporter_id)
      @loaded = true
    end
    self
  end
  
end