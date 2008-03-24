####################################################################################
####################################################################################
class AlnAggregator

  ##################################################################################
  def initialize(args)
    args.assert_valid_keys(:aggregated_model, :aggregator_class, :aggregator_name)
    @aggregated = args[:aggregated_model]
    @aggregator_class = args[:aggregator_class]
    @aggregator_name = args[:aggregator_name] || @aggregator_class.name.tableize.singularize
    @aggregator = nil
    @loaded = false
  end
  
  ##################################################################################
  def value=(v)
    @aggregator = v
    @aggregator.save if @aggregator.new_record?
    @aggregated.send("#{@aggregator_name}_id=".to_sym, @aggregator.id)
    @loaded = true
  end

  ##################################################################################
  def value
    @aggregator
  end
  
  ##################################################################################
  def method_missing(meth, *args, &blk)
    begin
      super
    rescue NoMethodError
      @aggregator.send(meth, *args, &blk)
    end
  end

  ##################################################################################
  def load?    
    id_from_aggregated.nil? ? false : @loaded
  end

  ##################################################################################
  def exists?
    not @aggregator.nil?
  end

  ##################################################################################
  def id
    @aggregator.nil? ? nil : @aggregator.id
  end

  ##################################################################################
  def eql?(val)
    @aggregator.eql?(val)
  end

  ##################################################################################
  def id_from_aggregated
    @aggregated.send("#{@aggregator_name}_id".to_sym)
  end
  
  ##################################################################################
  def load(*args)
    args[0].nil? ? force = false : force = args[0]
    unless self.load? and not force
      @aggregator = @aggregator_class.find(id_from_aggregated)
      @loaded = true
    end
    self
  end
  
end