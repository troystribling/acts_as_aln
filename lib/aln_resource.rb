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
    super
    clear_supported
  end

  #### delete all specified supported models
  def destroy_supported(model, *args)
    goner = find_supported(model, *args)
    if goner.class.eql?(Array)
      goner.each {|g| g.destroy}
    else
      goner.destroy unless goner.nil? 
    end
  end

  #### delete all supported models
  def clear_supported
    self.supported.each do |s|
      s.to_descendant.destroy
    end
  end

  def find_supported(model, *args)
    if args.first.eql?(:first) || args.first.eql?(:all)
      conditions << "aln_resource.supporter_id = #{id}"
      args[1].include?(:conditions) ? args[1][:conditions] << ' and ' + conditions : args[1][:conditions] = conditions
    end
    model.find(*args)
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
