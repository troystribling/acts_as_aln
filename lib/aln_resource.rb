class AlnResource < ActiveRecord::Base

  ####################################################################################
  #### declare descendant associations 
  ####################################################################################
  has_descendants
  
  ####################################################################################
  ##### declare support hierachy associations and define methods
  ####################################################################################
  belongs_to :supporter, :class_name => self.name, :foreign_key => "supporter_id" 
  has_many :supported, :class_name => self.name, :foreign_key => "supporter_id" , :dependent => :destroy
       
  ####################################################################################
  ##### save all models in hierarchy
  def save_hierarchy
    save
    supported.each {|sup| sup.save_hierarchy}
  end

  #### interate through support hierarchy
  def each
    yield self
    supported.each do |sup|
      sup.each {|x| yield x}
    end
  end
  
  #### add supported models
  def <<(sup)
    increment_depth if supported.count.eql?(0)
    if sup.class.eql?(Array)
      supported << sup.collect do |s|
        supported_as_aln_resource(s)
      end        
    else
      supported << supported_as_aln_resource(sup)
    end
  end  

  #### depth management
  def increment_depth
  puts "increment_depth = #{self.object_id}"
    self.hierarchy_depth += 1
    supporter.increment_depth unless supporter.nil?
  end
  
  def decrement_depth
    self.hierarchy_depth -= 1
    supporter.decrement_depth unless supporter.nil?
  end

  #### return model aln_resource ancestor
  def supported_as_aln_resource(mod)
    if mod.class.eql?(AlnResource)
      mod.supporter = self
      mod
    else
      if mod.respond_to?(:aln_resource)  
        mod.aln_resource.supporter = self
        mod.aln_resource
      else
        raise(PlanB::InvalidType, "target model is invalid")
      end
    end
  end
    
  #### delete all specified supported models
  def destroy_supported_by_model(model, *args)
    goner = find_supported_by_model(model, *args)
    if goner.class.eql?(Array)
      goner.each {|g| g.destroy}
    else
      goner.destroy unless goner.nil? 
    end
    decrement_depth if supported.count.eql?(0)
  end

  #### destroy model
  def destroy
    clear_supported
    super
  end

  #### delete all supported models and decrement depth
  def destroy_supported
    decrement_depth
    clear_supported
  end

  #### delete all supported models
  def clear_supported
    self.supported.each do |s|
      s.to_descendant.destroy
    end
  end

  #### find specified supported
  def find_supported_by_model(model, *args)
    self.class.find_by_model_and_condition("aln_resources.supporter_id = #{id}", model, *args)
  end

  #### find specified supporter
  def find_supporter_by_model(model)
    self.class.find_by_model_and_condition("aln_resources.aln_resource_id = #{self.supporter_id}", model, :first)
  end

  ####################################################################################
  class << self

    #### return roots of support hierachy
    def find_support_root_by_model(model, *args)
      find_by_model_and_condition("aln_resources.supporter_id is NULL", model, *args)
    end

    #### find model with specified condition
    def find_by_model_and_condition(condition, model, *args)
      if args.first.eql?(:first) || args.first.eql?(:all)
        if args[1].nil?
          args[1] = {:conditions => condition}
        else
          args[1].include?(:conditions) ? args[1][:conditions] << ' and ' + condition : args[1][:conditions] = condition
        end
      end
      model.find_by_model(*args)
    end

    #### return model aln_resource ancestor
    def aln_resource_ancestor(mod)
      if mod.class.eql?(AlnResource)
        mod 
      else
        mod.respond_to?(:aln_resource) ? mod.aln_resource :
          raise(PlanB::InvalidType, "target model is invalid")        
      end
    end
    
  end
        
end
