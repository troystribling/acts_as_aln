class AlnTermination < ActiveRecord::Base

   ###############################################################
   #### declare descendant associations and ancestor association
   #### with aln_resource
   ###############################################################
   has_descendants
   has_ancestor :named => :aln_resource   
   
   ###############################################################
   #### declare terminates association with aln_connection
   ###############################################################
   belongs_to :aln_termination_set  

   ###############################################################
   #### attribute validators
   ###############################################################
   validates_inclusion_of :directionality, 
                          :in => ['unidirectional', 'bidirectional'],
                          :message => "should be unidirectional or bidirectional",
                          :allow_nil => true

   validates_inclusion_of :direction,
                          :in => ['client', 'server'],
                          :message => "should be client or server",
                          :allow_nil => true

  ####################################################################################
  #### add supported model to model instance and update meta data
  def << (sup)
    new_network_id = self.get_network_id
    set_network_id = lambda do |s|
      s.network_id = new_network_id
      s.save
    end
    sup.class.eql?(Array) ? sup.each{|s| set_network_id[s]} : set_network_id[sup]
    self.aln_resource << sup
  end  

  ####################################################################################
  #### add network 
  def add_network (sup)
    update_network_id = lambda {|s| AlnTermination.update_all("network_id = #{self.get_network_id}", "network_id = #{s.get_network_id}")}
    sup.class.eql?(Array) ? sup.each{|s| update_network_id[s]} : update_network_id[sup]
    self.aln_resource.add_support_hierarchy(sup)
  end  

  ####################################################################################
  #### get network id
  def get_network_id
    if self.network_id.nil?
      self.save if self.id.nil?
      self.network_id = self.id
      self.save
    end
    self.network_id
  end
                   
  ####################################################################################
  # class methods
  class << self

    #### return model aln_termination
    def to_aln_termination(mod)
      if mod.class.eql?(AlnTermination)
        mod
      else
        mod.aln_termination
      end
    end
          
  end
                          
end
