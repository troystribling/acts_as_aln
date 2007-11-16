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
    sup.class.eql?(Array) ? sup.each{|s| update_network_id(s)} : update_network_id(sup)
    self.aln_resource << sup
  end  

  ####################################################################################
  #### add network 
  def add_network (sup)
    new_network_id = AlnTermination.get_network_id(self)
    sup.class.eql?(Array) ? sup.each{|s| s.network_id = new_network_id} : sup.network_id = new_network_id
    self.aln_resource << sup
  end  


  ####################################################################################
  #### update network id for supported
  def update_network_id(sup)
    sup_network_id = AlnTermination.get_network_id(sup)
    new_network_id = AlnTermination.get_network_id(self)
    self.class.update_all("nework_id = #{new_network_id}", "nework_id = #{sup_network_id}")     
  end
            
  ####################################################################################
  # class methods
  class << self

    ####################################################################################
    #### get network id
    def get_network_id(model)
      model.save if model.id.nil?
      model.network_id.nil? ? model.id : model.network_id
    end
                   
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
