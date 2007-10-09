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

  #### destroy model and all supported models
  def destroy
    self.supported.each {|s| s.to_descendant.destroy}
    super
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
    if sup.class.eql?(Array)
      supported << sup.collect do |s|
        increment_depth(s.support_hierarchy_depth)
        supported_as_aln_resource(s)
      end        
    else
      increment_depth(sup.support_hierarchy_depth)
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

  #### return model aln_resource supported
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

  #### destroy all supported and update meta data
  def destroy_supported
    self.supported.each {|s| s.to_descendant.destroy}
    self.supported.clear
    decrement_depth
  end

  #### destroy specified supporter and update meta data
  def destroy_supported_by_model(model, *args)
    goner = find_supported_by_model(model, *args)
    destroy_element = lambda do |e|
      e.destroy
      self.supported.delete(self.class.get_as_aln_resource(e))
    end
    if goner.class.eql?(Array)
      goner.each {|g| destroy_element[g]} 
    else
      destroy_element[goner] unless goner.nil? 
    end
    decrement_depth
  end

  #### destroy model and support hierarchy and update metadata
  def destroy_support_hierarchy
    destroy
    unless supporter.nil?
      supporter.supported.delete(self.class.get_as_aln_resource(self))
      supporter.decrement_depth
    end 
  end

  #### find specified supported
  def find_supported_by_model(model, *args)
    self.class.find_by_model_and_condition("aln_resources.supporter_id = #{self.id}", model, *args)
  end

  #### find specified supporter
  def find_supporter_by_model(model)
    self.class.find_by_model_and_condition("aln_resources.aln_resource_id = #{self.supporter_id}", model, :first)
  end

  #### increment hierarchy depth
  def increment_depth(depth)
    if depth >= self.support_hierarchy_depth
      self.support_hierarchy_depth = depth + 1  
      self.supporter.increment_depth(self.support_hierarchy_depth) unless self.supporter.nil?
    end
  end
  
  #### decrement hierarchy depth
  def decrement_depth
    if self.supported.empty?
      self.support_hierarchy_depth = 0
    else 
      self.support_hierarchy_depth = self.supported.collect {|s| s.support_hierarchy_depth}.max + 1
    end   
    self.supporter.decrement_depth unless self.supporter.nil?
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

    #### return model aln_resource
    def get_as_aln_resource(mod)
      if mod.class.eql?(AlnResource)
        mod
      else
        if mod.respond_to?(:aln_resource)  
          mod.aln_resource
        else
          raise(PlanB::InvalidType, "target model is invalid")
        end
      end
    end
          
  end
        
end
