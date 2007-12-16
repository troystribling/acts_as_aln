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
  def termination_supporter= (sup)
    self.create_termination_supporter    
    @termination_supporter.value = self.class.to_aln_termination(sup)
  end

  ####################################################################################
  #### add supported model to model instance and update meta data
  def << (sup)
    new_network_id = self.get_network_id
    set_network_id = lambda do |s|
      raise(PlanB::InvalidClass, "supported must be descendant of AlnTermination") unless s.class.class_hierarchy.include?(AlnTermination)
      s.network_id = new_network_id
      s.layer_id = self.layer_id + 1
      s.termination_supporter = self
      s.save
    end
    sup.class.eql?(Array) ? sup.each{|s| set_network_id[s]} : set_network_id[sup]
    self.aln_resource << sup
  end  

  #### add network 
  def add_network (sup)
    sup_network_id = sup.get_network_id
    new_network_id = self.get_network_id
    self.class.update_layer_ids_for_network(1, sup_network_id)
    sup.layer_id = self.layer_id + 1
    sup.termination_supporter = self  
    sup.network_id = new_network_id
    self.class.update_network_id(sup_network_id, new_network_id)   
    sup.save
    self.aln_resource.add_support_hierarchy(sup)
  end  

  ####################################################################################
  #### detach termination from support hierarchy
  def detach_support_hierarchy
    self.aln_resource.detach_support_hierarchy
    self.reload 
    self.termination_supporter_id = nil
    self.save
    self.detach_network
  end
    
  #### detach termination from network by assigning new network_id and appropriate
  #### layer_id
  def detach_network 
    self.id.eql?(self.get_network_id) ? new_network_id = self.supported.first.to_descendant(:aln_termination).id : new_network_id = self.id 
    self.reassign_network_id(new_network_id)
    self.reload
    self.reassign_layer_id_for_network(new_network_id)
    self.reload
  end  
#  def detach_network 
#    do_netork_metadata_update = lambda do
#      self.id.eql?(self.get_network_id) ? new_network_id = self.supported.first.to_descendant(:aln_termination).id : new_network_id = self.id 
#      self.reassign_network_id(new_network_id)
#      self.reload
#      self.reassign_layer_id_for_network(new_network_id)
#      self.reload
#    end
#    if self.has_supported?
#      do_netork_metadata_update[]
#    else
#      if self.get_connected_peer_terminations.detect{|t| t.in_connection?}.nil?
#        self.id.eql?(self.get_network_id) ? new_network_id = self.supporter.to_descendant(:aln_termination).id : new_network_id = self.id 
#        self.network_id = new_network_id
#        self.layer_id = 0
#        self.save  
#      else
#        do_netork_metadata_update[]
#      end
#    end
#  end  

  #### assign new network id for detached network
  def reassign_network_id (new_network_id) 
    term_root = self.find_root_termination_supporter
    term_root.update_support_hierrachy_network_id(new_network_id)
    term_root.find_connected_terminations_in_support_hierarchy.each do |t| 
      t.get_connected_peer_terminations.each do |pt| 
        pt.reassign_network_id(new_network_id) unless pt.network_id.eql?(new_network_id)
      end
    end
  end  

  #### change layer_id for specified network
  def reassign_layer_id_for_network (network_id)
    term_roots = self.class.find_termination_roots_in_network_by_model(AlnTermination, network_id)
    min_layer_id = term_roots.inject(term_roots.first.layer_id) {|mlid, t| mlid > t.layer_id ? t.layer_id : mlid}
    self.class.update_layer_ids_for_network(-min_layer_id, network_id)
  end

  ####################################################################################
  #### update network id for termination support hierarchy
  def update_support_hierrachy_network_id (new_network_id)
    AlnTermination.find_by_model(:all, :conditions => "aln_resources.support_hierarchy_left between #{self.support_hierarchy_left} AND #{self.support_hierarchy_right} AND aln_resources.support_hierarchy_root_id = #{self.support_hierarchy_root_id}", :readonly => false).each do |t| 
      t.network_id = new_network_id
      t.save
    end
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
  #### true if termination is in a connection
  def in_connection?
    self.aln_connection_id.nil? ? false : true
  end

  #### true if termination is in a path
  def in_path?
    self.aln_path_id.nil? ? false : true
  end

  ####################################################################################
  #### find connected terminations in support hierarchy
  def find_connected_terminations_in_support_hierarchy
    self.aln_resource.find_in_support_hierarchy_by_model(AlnTermination, :all, :conditions => "aln_terminations.aln_connection_id IS NOT NULL")
  end

  #### find root termination supporter
  def find_root_termination_supporter
    ([self] + self.find_all_supporters_by_model(AlnTermination)).last
  end
  
  #### return connection peer terminations
  def get_connected_peer_terminations
    if in_connection? 
      self.aln_connection.aln_terminations.to_ary.delete(self)
      self.aln_connection.aln_terminations
    else 
      []
    end 
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
    #### find termination roots in specified network
    def find_termination_roots_in_network_by_model (model, network_id)
      model.find_by_model(:all, :conditions => "aln_terminations.network_id = #{network_id} AND aln_terminations.termination_supporter_id IS NULL")
    end
  
    ####################################################################################
    #### find termination roots in support hierarchy
    def find_termination_roots_in_support_hierarchy_by_model (model, sup)
    end
    
    ####################################################################################
    #### set the layer id for specified network
    def update_layer_ids_for_network (layer_id_increment, network_id)
      self.update_all("layer_id = (layer_id + #{layer_id_increment})", "network_id = #{network_id}")
    end
  
    ####################################################################################
    #### update the specified network ID
    def update_network_id (old_network_id, new_network_id)
      self.update_all("network_id = #{new_network_id}", "network_id = #{old_network_id}") unless new_network_id.eql?(old_network_id)
    end
  
    ####################################################################################
    #### find maximum layer_id for specified network
    def find_max_layer_id_by_network_id (network_id)
      self.find_by_sql("SELECT MAX(layer_id) FROM aln_terminations WHERE network_id=#{network_id}").first.attributes["MAX(layer_id)"].to_i
    end
            
  end
                          
end
