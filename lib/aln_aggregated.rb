####################################################################################
####################################################################################
class AlnAggregated

  ##################################################################################
  def initialize(args)
    args.assert_valid_keys(:aggregator_model, :aggregated_class, :aggregator_name)
    @aggregator = args[:aggregator_model]
    @aggregated_class = args[:aggregated_class]
    @aggregator_name = args[:aggregator_name] || @aggregator.class.name.tableize.singularize
    @aggregator.save if @aggregator.new_record?
    @aggregated = []
    @loaded = false
  end
  
  ##################################################################################
  def method_missing(meth, *args, &blk)
    begin
      super
    rescue NoMethodError
      @aggregated.send(meth, *args, &blk)
    end
  end

  ##################################################################################
  def count
    load.length
  end

  ##################################################################################
  def to_a
    @aggregated
  end

  ##################################################################################
  def << (mod)
    if mod.class.eql?(Array)
      mod.each{|m| set_aggregator(m, @aggregator)}
    else
      set_aggregator(mod, @aggregator)
      mod = [mod]
    end
    @aggregated += mod
  end
  
  ##################################################################################
  def set_aggregator(aggregated, aggregator)
    aggregated.send("#{@aggregator_name}=".to_sym, aggregator)
  end
  
  ##################################################################################
  def loaded?
    @loaded
  end
  
  ##################################################################################
  def load(*args)
    args[0].nil? ? force = false : force = args[0]
    unless loaded? and not force
      @aggregated = @aggregated_class.send("find_all_by_#{@aggregator_name}_id".to_sym, @aggregator.id)
      @aggregated.each{|m| set_aggregator(m, @aggregator)}
      @loaded = true
    end
    self
  end
  
end