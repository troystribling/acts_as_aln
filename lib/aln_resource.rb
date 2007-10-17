####################################################################################
#### ALN Resource model
####################################################################################
class AlnResource < ActiveRecord::Base

  ####################################################################################
  #### declare descendant associations 
  ####################################################################################
  has_descendants
  
  ####################################################################################
  ##### declare instance attributes
  ####################################################################################
  attr_accesor :supporter

  ####################################################################################
  def supporter=(sup)
    @supporter = sup
    self.supporter_id = @supporter.id
  end
         
  ####################################################################################
  ##### initialize model
  def initialize
    @supported = AlnSupported.new
  end
  
  ####################################################################################
  ##### save entire hierarchy
  def save_hierarchy
    save
    supported.each {|sup| sup.save_hierarchy}
  end

  #### destroy model and all supported models
  def destroy
    self.supported.each {|s| s.to_descendant.destroy}
    super
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
    self.to_descendant.destroy
    unless supporter.nil?
      supporter.supported.delete(self.class.get_as_aln_resource(self))
      supporter.decrement_depth
    end 
  end
  
  ####################################################################################
  #### interate through support hierarchy
  def each
    yield self
    supported.each do |sup|
      sup.each {|x| yield x}
    end
  end
  
  ####################################################################################
  #### add supported model to model instance
  def << (sup)
    sup.class.eql?(Array) ? sup.each{|s| increment_metadata(s)} : increment_metadata(sup)
    @supported << sup
  end  

  #### add supported model to model instance
  def move_supported (sup)
    sup.class.eql?(Array) ? sup.each{|s| increment_metadata(s)} : increment_metadata(sup)
    @supported << sup
  end  

  #### supported
  def supported
    @supported.load(self) unless @supported.loaded?
    @supported
  end
  
  ####################################################################################
  def increment_metadata(sup)
    sup.support_hierarchy_left = self.support_hierarchy_left + 1
    sup.support_hierarchy_right = self.support_hierarchy_left + 2
    self.support_hierarchy_root.nil? ? sup.support_hierarchy_root = self.id : sup.support_hierarchy_root = self.support_hierarchy_root
    self.class.update_all("support_hierarchy_left = (support_hierarchy_left + 2)", "support_hierarchy_left > #{sup.support_hierarchy_left}") 
    self.class.update_all("support_hierarchy_right = (support_hierarchy_right + 2)", "support_hierarchy_right > #{sup.support_hierarchy_right}") 
  end

  ####################################################################################
  def decrement_metadata(sup)
  end
  
  ####################################################################################
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
        raise(PlanB::InvalidClass, "target model is invalid")
      end
    end
  end

  ####################################################################################
  #### find specified supported
  def find_supported_by_model(model, *args)
    self.class.find_by_model_and_condition("aln_resources.supporter_id = #{self.id}", model, *args)
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

    #### return model aln_resource
    def get_as_aln_resource(mod)
      if mod.class.eql?(AlnResource)
        mod
      else
        if mod.respond_to?(:aln_resource)  
          mod.aln_resource
        else
          raise(PlanB::InvalidClass, "target model is invalid")
        end
      end
    end
          
  end
        
end
