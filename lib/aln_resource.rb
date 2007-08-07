class AlnResource < ActiveRecord::Base

  ####################################################################################
  #### declare descendant associations and ancestor association
  #### with aln_thing
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
    if sup.class.eql?(Array)
      supported << sup.collect do |s|
        self.class.get_as_aln_resource(s)
      end        
    else
      supported << self.class.get_as_aln_resource(sup)
    end
  end  

  #### destroy model
  def destroy
    if AlnResource.exists?(self.id)
      super
      self.supported.each do |s|
        s.to_descendant.destroy
      end
    end
  end

  #### delete specified supported model
  def destroy_supported(conds)  
    self.supported.find(:first, :conditions => conds).to_descendant.destroy
  end

  #### delete all specified supported models
  def destroy_all_supported(conds)
    self.supported.find(:all, :conditions => conds).each do |s|
      s.to_descendant.destroy
    end
  end

  #### delete all supported models
  def clear_supported
    self.supported.each do |s|
      s.to_descendant.destroy
    end
  end
  
  #### find specified supported model
  def find_supported(conds)
    self.supported.find(:first, :conditions => conds).to_descendant
  end

  #### find all specified supported models
  def find_all_supported(conds)
    self.supported.find(:all, :conditions => conds).collect do |s|
      s.to_descendant
    end
  end

  ####################################################################################
  class << self

    #### return roots of support hierachy
    def find_root
      find_all_by_supporter_id(nil).collect do |r|
        r.to_descendant
      end
    end

    #### return model as aln_resource
    def get_as_aln_resource(mod)
      if mod.class.eql?(AlnResource)
        mod 
      else
        mod.respond_to?(:aln_resource) ? mod.aln_resource :
          raise(PlanB::InvalidType, "target model is invalid")        
      end
    end
    
  end
        
end
