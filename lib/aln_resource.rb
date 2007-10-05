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
  @@supported_reflection = create_has_many_reflection(:supported, :class_name => self.name, :foreign_key => "supporter_id")
       
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
    increment_depth(self.support_hierarchy_depth) if supported.length.eql?(0)
    if sup.class.eql?(Array)
      supported << sup.collect do |s|
        supported_as_aln_resource(s)
      end        
    else
      supported << supported_as_aln_resource(sup)
    end
  end  

  #### supported
  def supported (*params)
    force_reload = params.first unless params.empty?
    association = instance_variable_get("@supported")
    set_supporter = lambda {association.each{|a| a.supporter = self}}
    unless association.respond_to?(:loaded?)
      association = ActiveRecord::Associations::HasManyAssociation.new(self, @@supported_reflection)
      instance_variable_set("@supported", association)
      set_supporter[]
    end
    if force_reload
      association.reload
      set_supporter[]
    end
    association
  end

  #### depth management
  def increment_depth(supported_depth)
    self.support_hierarchy_depth = supported_depth + 1 if supported_depth >= self.support_hierarchy_depth 
    supporter.increment_depth(self.support_hierarchy_depth) unless supporter.nil?
  end
  
  def decrement_depth(supported_depth)
  puts "supported.length: #{supported.length}"
    if supported.length.eql?(0)
  puts "decrement_depth:supported_depth #{supported_depth}"
  puts "decrement_depth:support_hierarchy_depth #{self.support_hierarchy_depth}"
      supporter.decrement_depth(self.support_hierarchy_depth) unless supporter.nil?
      self.support_hierarchy_depth = self.support_hierarchy_depth - supported_depth
  puts "decrement_depth:decremented support_hierarchy_depth #{self.support_hierarchy_depth}"
    end
  puts ""
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
    puts "destroy_supported_by_model"
    decrement_depth(self.support_hierarchy_depth)
  end

  #### destroy model
  def destroy
    puts "destroy"
    destroy_supported
    super
  end

  #### delete all supported models and decrement depth
  def destroy_supported
    puts "destroy_supported"
    self.supported.each do |s|
      s.to_descendant.destroy
    end
    decrement_depth(self.support_hierarchy_depth)
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
          raise(PlanB::InvalidClass, "target model is invalid")        
      end
    end
    
  end
        
end
