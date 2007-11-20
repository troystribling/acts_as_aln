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
    @supporter.value = AlnResource.to_aln_resource(sup)
  end
         
  #### supported
  def supported(*args)
    @supported = AlnSupported.new(self) if @supported.nil?
    @supported.load(*args)
  end
    
  ####################################################################################
  ##### update entire hierarchy
  def save_hierarchy
    save
    supported.each {|sup| sup.save_hierarchy}
  end

  ####################################################################################
  #### destroy model and all supported models
  def destroy
    self.supported.each {|s| s.to_descendant.destroy}
    super
  end

  ####################################################################################
  #### destroy model and update meta data
  def destroy_as_supported
    remove_update_metadata(2, self.support_hierarchy_left, self.class.get_support_hierarchy_root_id(self))
    self.to_descendant.destroy
  end

  ####################################################################################
  #### destroy all supported models and update meta data
  def destroy_all_supported
    supported.each {|sup| sup.destroy_as_supported}
  end

  ####################################################################################
  #### destroy specified supporter and update meta data
  def destroy_supported_by_model(model, *args)
    goner = find_supported_by_model(model, *args)
    if goner.class.eql?(Array)
      goner.each {|g| g.destroy_as_supported} 
    else
      goner.destroy_as_supported unless goner.nil? 
    end
  end

  ####################################################################################
  #### destroy model and support hierarchy and update metadata
  def destroy_support_hierarchy
    detach_support_hierarchy
    self.to_descendant.destroy
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
    update_metadata = lambda{|m| add_update_metadata(m, 2, self.support_hierarchy_left, self.class.get_support_hierarchy_root_id(self))}
    sup.class.eql?(Array) ? sup = sup.collect{|s| self.class.to_aln_resource(s)} : sup = self.class.to_aln_resource(sup)
    supported << sup
    sup.class.eql?(Array) ? sup.each{|s| update_metadata[s]} : update_metadata[sup]
    supported.load(true)
  end  

  ####################################################################################
  #### add support hierarchy  and update metadata
  def add_support_hierarchy(sup)
    sup = self.class.to_aln_resource(sup)
    supported << sup
    add_update_all(self.support_hierarchy_left-sup.support_hierarchy_left+1, sup.support_hierarchy_left, self.class.get_support_hierarchy_root_id(sup))
    add_update_metadata(sup, sup.support_hierarchy_right-sup.support_hierarchy_left+1, self.support_hierarchy_left, self.class.get_support_hierarchy_root_id(self))
    AlnResource.update_all("support_hierarchy_root_id = #{self.class.get_support_hierarchy_root_id(self)}", "supporter_id = #{sup.id}") 
    supported.load(true)
  end  

  ####################################################################################
  #### update meta data for all impacted models and save updates to database when
  #### a supported is added to hierarchy
  def add_update_metadata(sup, update_increment, left_lower_bound, root_id)
        
    #### update meta data for all affected models
    add_update_all(update_increment, left_lower_bound, root_id)
    
    ### update new supported metadata
    sup.support_hierarchy_left = left_lower_bound + 1
    sup.support_hierarchy_right += left_lower_bound
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
  #### update meta data for all impacted models and save updates to database when
  #### a supported is added to hierarchy
  def add_update_all(update_increment, left_lower_bound, root_id) 
    AlnResource.update_all("support_hierarchy_left = (support_hierarchy_left + #{update_increment})", "support_hierarchy_left > #{left_lower_bound} AND support_hierarchy_root_id = #{root_id}") 
    AlnResource.update_all("support_hierarchy_right = (support_hierarchy_right + #{update_increment})", "support_hierarchy_right > #{left_lower_bound + 1} AND support_hierarchy_root_id = #{root_id}") 
  end
  
  ####################################################################################
  ####################################################################################
  #### detach from support hierarchy
  def detach_support_hierarchy
  
    right = self.support_hierarchy_right
    left = self.support_hierarchy_left
    root_id = self.class.get_support_hierarchy_root_id(self)

    self.support_hierarchy_root_id = nil
    self.supporter_id = nil
    self.support_hierarchy_right += 1 - left
    self.support_hierarchy_left = 1
    self.save

    AlnResource.update_all("support_hierarchy_root_id = #{self.id}", "supporter_id = #{self.id}") 
    remove_update_metadata(right-left+1, left, root_id)
    remove_update_metadata(left-1, 1, self.id)

    supported.load(true)
    
  end  

  ####################################################################################
  #### update meta data for all impacted models and save updates to database
  def remove_update_metadata(update_increment, left_lower_bound, root_id)

    #### update meta data for all affected models
    AlnResource.update_all("support_hierarchy_left = (support_hierarchy_left - #{update_increment})", "support_hierarchy_left > #{left_lower_bound + 1} AND support_hierarchy_root_id = #{root_id}") 
    AlnResource.update_all("support_hierarchy_right = (support_hierarchy_right - #{update_increment})", "support_hierarchy_right > #{left_lower_bound + 1} AND support_hierarchy_root_id = #{root_id}") 
    
    ### if model is not hierahcy root also update root
    unless root_id.eql?(self.id)
      hierarchy_root = AlnResource.find(root_id)
      hierarchy_root.support_hierarchy_right -= update_increment
      hierarchy_root.save
    end 
       
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
  # class methods
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
    def to_aln_resource(mod)
      if mod.class.eql?(AlnResource)
        mod
      else
        mod.aln_resource
      end
    end
          
  end
        
end
