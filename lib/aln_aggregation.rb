####################################################################################
####################################################################################
module AlnAggregation

  ######################################################################################################
  def self.included(base) 
    base.extend(ClassMethods)  
  end

  ####################################################################################
  ####################################################################################
  module ClassMethods

    ######################################################################################################
    def aggregated_by(args)
            
      args.assert_valid_keys(:aggregator_class, :aggregator_name)
      @aggregator_class = args[:aggregator_class]
      @aggregator_name = args[:aggregator_name] || @aggregator_class.name.tableize.singularize
        
      ######################################################################################################
      class_eval <<-do_eval

        def #{@aggregator_name}(*args)
          unless self.#{@aggregator_name}_id.nil?
             self.create_#{@aggregator_name}_aggregator    
            @#{@aggregator_name}_aggregator.load(*args).value
          end
        end
        
        def create_#{@aggregator_name}_aggregator
          @#{@aggregator_name}_aggregator = AlnAggregator.new(:aggregated_model => self, :aggregator_class => #{@aggregator_class}, :aggregator_name => "#{@aggregator_name}") if @#{@aggregator_name}_aggregator.nil?
        end
          
        def #{@aggregator_name}=(agg)
          if agg
            self.create_#{@aggregator_name}_aggregator    
            @#{@aggregator_name}_aggregator.value = #{@aggregator_class}.to_#{@aggregator_class.name.tableize.singularize}(agg)
          else
            @#{@aggregator_name}_aggregator = nil
          end
        end
        
        def has_#{@aggregator_name}?
          self.#{@aggregator_name}.nil? ? false : true
        end
          
      do_eval

    end

    ######################################################################################################
    def aggregator_of(args)
      args.assert_valid_keys(:aggregated_class, :aggregator_name, :aggregated_name)
      @aggregated_class = args[:aggregated_class]
      @aggregated_name = args[:aggregated_name] || @aggregated_class.name.tableize
      @aggregator_name = args[:aggregator_name] || self.name.tableize.singularize

      ######################################################################################################
      class_eval <<-do_eval

        def #{@aggregated_name}(*args)
          @#{@aggregator_name}_aggregated = AlnAggregated.new(:aggregator_model => self, :aggregated_class => #{@aggregated_class}, :aggregator_name => "#{@aggregator_name}") if @#{@aggregator_name}_aggregated.nil?
          @#{@aggregator_name}_aggregated.load(*args)
        end
          
        def has_#{@aggregated_name}?
          #{@aggregated_name}.empty? ? false : true
        end
                   
      do_eval

    end
        
  ######################################################################################################
  end 
  
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
    
  ####################################################################################
  end
  
  
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
    
  ####################################################################################
  end

####################################################################################
end