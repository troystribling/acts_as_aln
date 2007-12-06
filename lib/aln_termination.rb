class AlnTermination < ActiveRecord::Base

  ###############################################################
  #### mixins
  extend AlnHelper

  ###############################################################
  #### declare descendant associations and ancestor association
  #### with aln_resource
  ###############################################################
  has_descendants
  has_ancestor :named => :aln_resource   
  
  ###############################################################
  #### declare terminates associations with aln_connection and
  #### aln_path
  ###############################################################
  belongs_to :aln_connection  
  belongs_to :aln_path  
  
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
  #### instance attributes
  ####################################################################################
  #### termination supporter
  def termination_supporter(*args)
    unless self.termination_supporter_id.nil?
       self.create_termination_supporter    
      @termination_supporter.load(*args)
    end
  end

  #### set supporter
  def create_termination_supporter
   @termination_supporter = AlnSupporter.new(self, :termination_supporter_id) if @termination_supporter.nil?
  end
  
  #### set supporter
  def termination_supporter=(sup)
    self.create_termination_supporter    
    @termination_supporter.value = self.class.to_aln_termination(sup)
  end

  ####################################################################################
  #### add supported model to model instance and update meta data
  def << (sup)
    new_network_id = self.get_network_id
    set_network_id = lambda do |s|
      s.network_id = new_network_id
      s.layer_id = self.layer_id + 1
      s.termination_supporter = self
      s.save
    end
    sup.class.eql?(Array) ? sup.each{|s| set_network_id[s]} : set_network_id[sup]
    self.aln_resource << sup
  end  

  ####################################################################################
  #### add network 
  def add_network (sup)
    sup_network_id = sup.get_network_id
    new_network_id = self.get_network_id
    self.class.update_layer_ids_for_network(sup.layer_id, self.layer_id + 1, sup_network_id)
    sup.layer_id = self.layer_id + 1
    sup.termination_supporter = self  
    sup.network_id = new_network_id
    self.class.update_network_id(sup_network_id, new_network_id)   
    sup.save
    self.aln_resource.add_support_hierarchy(sup)
  end  

  ####################################################################################
  #### detach network from support hierarchy
  def detach_network  
     self.aln_resource.detach_network    
  end  

  ####################################################################################
  #### migrate termination support hierarchy to new network
  def migrate_support_hierrachy_to_network (new_network_id)
    self.network_id = new_network_id
    self.connection.execute("UPDATE aln_resources, aln_terminations SET aln_terminations.network_id = #{new_network_id} WHERE aln_resources.support_hierarchy_left > #{self.support_hierarchy_left} AND aln_resources.support_hierarchy_right < #{self.support_hierarchy_right}")
    self.save
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

    ####################################################################################
    #### return model aln_termination
    def to_aln_termination(mod)
      mod.class.eql?(AlnTermination) ? mod : mod.aln_termination
    end

    ####################################################################################
    #### set the layer id for specified network
    def update_layer_ids_for_network (old_layer_id, new_layer_id, network_id)
      max_layer_id = self.find_max_layer_id_by_network_id(network_id)
      (0..max_layer_id).to_a.reverse.each{|l| self.update_all("layer_id = #{new_layer_id + l}", "layer_id = #{old_layer_id + l} AND network_id = #{network_id}")}
    end
  
    ####################################################################################
    #### update the specified network ID
    def update_network_id (old_network_id, new_network_id)
      self.update_all("network_id = #{new_network_id}", "network_id = #{old_network_id}")
    end
  
    ####################################################################################
    #### find maximum layer_id for specified network
    def find_max_layer_id_by_network_id (network_id)
      self.find_by_sql("SELECT MAX(layer_id) FROM aln_terminations WHERE network_id=#{network_id}").first.attributes["MAX(layer_id)"].to_i
    end
            
  end
                          
end
