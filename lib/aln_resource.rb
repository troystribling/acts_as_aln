####################################################################################
#### ALN Resource model
####################################################################################
class AlnResource < ActiveRecord::Base

  ####################################################################################
  #### declare descendant associations 
  ####################################################################################
  has_descendants
  
  ####################################################################################
  #### instance attributes
  ####################################################################################
  #### supporter
  def supporter(*args)
    unless self.supporter_id.nil?
       self.create_supporter    
      @supporter.load(*args)
    end
  end

  #### set supporter
  def create_supporter
   @supporter = AlnSupporter.new(self) if @supporter.nil?
  end
  
  #### set supporter
  def supporter=(sup)
    self.create_supporter    
    @supporter.value = self.class.get_as_aln_resource(sup)
  end
         
  #### supported
  def supported(*args)
    @supported = AlnSupported.new(self) if @supported.nil?
    @supported.load(*args)
  end
    
  ####################################################################################
  ##### update entire hierarchy
  def update_hierarchy
    save
    supported.each {|sup| sup.save_hierarchy}
  end

  #### destroy model and all supported models
  def destroy
    self.supported.each {|s| s.to_descendant.destroy}
    super
  end

  #### destroy model and update meta data
  def destroy_as_supported
    decrement_metadata
  end

  #### destroy all supported models and update meta data
  def destroy_all_supported
    supported.each {|sup| sup.destroy_as_supported}
    self.supported.clear
  end

  #### destroy specified supporter and update meta data
  def destroy_supported_by_model(model, *args)
    goner = find_supported_by_model(model, *args)
    destroy_element = lambda do |e|
      e.destroy_as_supported
      self.supported.delete(self.class.get_as_aln_resource(e))
    end
    if goner.class.eql?(Array)
      goner.each {|g| destroy_element[g]} 
    else
      destroy_element[goner] unless goner.nil? 
    end
  end

  #### destroy model and support hierarchy and update metadata
  def destroy_support_hierarchy
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
    sup = sup.collect{|s| self.class.get_as_aln_resource(s)} if sup.class.eql?(Array)
    supported << sup
    sup.class.eql?(Array) ? sup.each{|s| increment_metadata(s)} : increment_metadata(sup)
    supported.load(true)
  end  

  #### add supported model to model instance
  def move_supported (sup)
    supported << sup
    sup.class.eql?(Array) ? sup.each{|s| increment_metadata(s)} : increment_metadata(sup)
  end  

  ####################################################################################
  #### increment meta data for all impacted models and save updates to database
  def increment_metadata(sup)
    
    #### determine update increment and hierarchy root
    root_id = self.class.get_support_hierarchy_root_id(self)
    sup_root_id = self.class.get_support_hierarchy_root_id(sup)
    sup.supporter_id.nil? ? sup_supporter_id = sup.id : sup_supporter_id = sup.supporter_id
    update_increment = sup.support_hierarchy_right
    sup_update_increment = self.support_hierarchy_left
    
#    p sup_supporter_id
#    p sup_root_id
#    
    #### update meta data for all affected models
    self.class.update_all("support_hierarchy_left = (support_hierarchy_left + #{update_increment})", "support_hierarchy_left > #{self.support_hierarchy_left} AND support_hierarchy_root_id = #{root_id}") 
    self.class.update_all("support_hierarchy_right = (support_hierarchy_right + #{update_increment})", "support_hierarchy_right > #{self.support_hierarchy_left + 1} AND support_hierarchy_root_id = #{root_id}") 

    ### update subtree
    self.class.update_all("support_hierarchy_left = (support_hierarchy_left + #{sup_update_increment})", "support_hierarchy_root_id = #{sup_root_id} AND supporter_id = #{sup_supporter_id}") 
    self.class.update_all("support_hierarchy_right = (support_hierarchy_right + #{sup_update_increment})", "support_hierarchy_root_id = #{sup_root_id} AND supporter_id = #{sup_supporter_id}") 
    self.class.update_all("support_hierarchy_root_id = #{root_id}", "support_hierarchy_root_id = #{sup_root_id} AND supporter_id = #{sup_supporter_id}") 
    
    ### update new supported metadata
    sup.support_hierarchy_left += sup_update_increment
    sup.support_hierarchy_right += sup_update_increment
    sup.support_hierarchy_root_id = root_id
    sup.save
    
    ### update model meta data and save
    self.support_hierarchy_right += update_increment
    self.save
    
    ### if model is not hierahcy root also update root
    unless root_id.eql?(self.id)
      hierarchy_root = AlnResource.find(root_id)
      hierarchy_root.support_hierarchy_right += update_increment
      hierarchy_root.save
    end 
    
  end

  ####################################################################################
  def decrement_metadata

    #### determine update increment and hierarchy root
    self.support_hierarchy_root_id.nil? ? root_id = self.id : root_id = self.support_hierarchy_root_id
    update_increment = 2

    #### update meta data for all affected models
    self.class.update_all("support_hierarchy_left = (support_hierarchy_left - #{update_increment})", "support_hierarchy_left > #{self.support_hierarchy_left + 1} AND support_hierarchy_root_id = #{root_id}") 
    self.class.update_all("support_hierarchy_right = (support_hierarchy_right - #{update_increment})", "support_hierarchy_right > #{self.support_hierarchy_left + 1} AND support_hierarchy_root_id = #{root_id}") 
    
    ### if model is not hierahcy root also update root
    unless root_id.eql?(self.id)
      hierarchy_root = AlnResource.find(root_id)
      hierarchy_root.support_hierarchy_right -= update_increment
      hierarchy_root.save
    end 

    ### destroy supported
    self.to_descendant.destroy
       
  end

#  ####################################################################################
#  #### increment meta data for all impacted models and save updates to database
#  def increment_metadata(sup)
#    
#    #### determine update increment and hierarchy root
#    root_id = self.get_support_hierarchy_root_id
#    update_increment = 2
#    
#    #### update meta data for all affected models
#    self.class.update_all("support_hierarchy_left = (support_hierarchy_left + #{update_increment})", "support_hierarchy_left > #{self.support_hierarchy_left} AND support_hierarchy_root_id = #{root_id}") 
#    self.class.update_all("support_hierarchy_right = (support_hierarchy_right + #{update_increment})", "support_hierarchy_right > #{self.support_hierarchy_left + 1} AND support_hierarchy_root_id = #{root_id}") 
#
#    ### update new supported metadata
#    sup.support_hierarchy_left = self.support_hierarchy_left + 1
#    sup.support_hierarchy_right = self.support_hierarchy_left + 2
#    sup.support_hierarchy_root_id = root_id
#    sup.save
#    
#    ### update model meta data and save
#    self.support_hierarchy_right += update_increment
#    self.save
#    
#    ### if model is not hierahcy root also update root
#    unless root_id.eql?(self.id)
#      hierarchy_root = AlnResource.find(root_id)
#      hierarchy_root.support_hierarchy_right += update_increment
#      hierarchy_root.save
#    end 
#    
#  end
#
#  ####################################################################################
#  def decrement_metadata
#
#    #### determine update increment and hierarchy root
#    self.support_hierarchy_root_id.nil? ? root_id = self.id : root_id = self.support_hierarchy_root_id
#    update_increment = 2
#
#    #### update meta data for all affected models
#    self.class.update_all("support_hierarchy_left = (support_hierarchy_left - #{update_increment})", "support_hierarchy_left > #{self.support_hierarchy_left + 1} AND support_hierarchy_root_id = #{root_id}") 
#    self.class.update_all("support_hierarchy_right = (support_hierarchy_right - #{update_increment})", "support_hierarchy_right > #{self.support_hierarchy_left + 1} AND support_hierarchy_root_id = #{root_id}") 
#    
#    ### if model is not hierahcy root also update root
#    unless root_id.eql?(self.id)
#      hierarchy_root = AlnResource.find(root_id)
#      hierarchy_root.support_hierarchy_right -= update_increment
#      hierarchy_root.save
#    end 
#
#    ### destroy supported
#    self.to_descendant.destroy
#       
#  end
  
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
  #### find specified directly supported
  def find_supported_by_model(model, *args)
    self.class.find_by_model_and_condition("aln_resources.supporter_id = #{self.id}", model, *args)
  end

  #### find specified supporter by specified model
  def find_supporter_by_model(model)
    self.class.find_by_model_and_condition("aln_resources.aln_resource_id = #{self.supporter_id}", model, :first)
  end

  #### find specified supporter within entier hierarchy
  def find_in_support_hierarchy_by_model(model, *args)
    cond = "aln_resources.support_hierarchy_left between #{self.support_hierarchy_left} and #{self.support_hierarchy_right} and aln_resources.support_hierarchy_root_id = #{self.class.get_support_hierarchy_root_id(self)}"
    if args.first.eql?(:all)
      order = "aln_resources.support_hierarchy_left DESC"
      if args[1].nil?
        args[1] = {:order => order}
      else
        args[1].include?(:order) ? args[1][:order] << ', ' + order : args[1][:order] = order
      end
    end
    self.class.find_by_model_and_condition(cond, model, *args)
  end
  
  ####################################################################################
  class << self

    #### return roots of support hierachy
    def find_support_hierarchy_root_by_model(model, *args)
      find_by_model_and_condition("aln_resources.supporter_id is NULL", model, *args)
    end

    #### get support_hierarchy_root_id
    def get_support_hierarchy_root_id(model)
      model.save if model.id.nil?
      model.support_hierarchy_root_id.nil? ? model.id : model.support_hierarchy_root_id
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
