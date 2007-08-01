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
        supported << s.aln_resource
      end        
    else
      supported << sup.aln_resource
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
