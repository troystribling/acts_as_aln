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

  #### find specified model with specified attribute value
  def fetch_by_attr(mod, by_attr, attr_val)
    if mod.to_s.classify.eql?(supported_type)
      val = supported.detect do |sup| 
        attr_val == sup.down_cast(mod).send(by_attr)
      end
      val.down_cast(mod) unless val.nil?
    else
      val = nil
      supported.each do |sup|
        val = sup.fetch_by_attr(mod, by_attr, attr_val)
        break unless val.nil?
      end
      val
    end  
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
      sup.each do |s|
        supported << s.aln_support_hierarchy
      end        
    else
      supported << sup.aln_support_hierarchy
    end
  end
  
  
  ####################################################################################
  class << self
    #### return roots of support hierachy
    def self.find_root
      find_all_by_supporter_id(nil)
    end
  end
      
end
