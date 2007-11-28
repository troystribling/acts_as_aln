class AlnConnection < ActiveRecord::Base

  ###############################################################
  #### declare descendant associations and ancestor association
  #### with aln_resource
  ###############################################################
  has_descendants
  has_ancestor :named => :aln_termination_set   

  ####################################################################################
  #### add termination to connection
  def << (term)    
    self.aln_termination_set.validate_termination(term)    
    add_first_term = lambda do |t| 
      t.get_network_id 
      self.aln_termination_set.aln_terminations << AlnTermination.to_aln_termination(t)
    end
    add_term = lambda do |t| 
      self.update_layer_id(t, false)
      t.network_id = self.aln_termination_set.aln_terminations.first.network_id 
      t.save
      self.aln_termination_set.aln_terminations << AlnTermination.to_aln_termination(t)
    end
    if self.aln_terminations.empty?
      if term.class.eql?(Array) 
        add_first_term[term.shift]
        term.each{|t| add_term[t]} 
      else
        add_first_term[term]
      end
    else
      term.class.eql?(Array) ? term.each{|t| add_term[t]} : add_term[term]
    end
    self.save
  end  

  ####################################################################################
  #### add network to connection
  def add_network (term)
    self.aln_termination_set.validate_termination(term)
    unless self.aln_terminations.empty? 
      self.update_layer_id(term, true)
      connection_network_id = self.aln_termination_set.aln_terminations.first.network_id
      term_network_id = term.get_network_id
      term.network_id = connection_network_id
      term.save
      AlnTermination.update_network_id(term_network_id, connection_network_id)
    else
      term.get_network_id 
    end     
    self.aln_termination_set.aln_terminations << AlnTermination.to_aln_termination(term)
    self.save
  end  

  ####################################################################################
  #### update layer_id
  def update_layer_id (term, update_all)
    term_layer_id = term.layer_id
    connection_layer_id = self.aln_termination_set.aln_terminations.first.layer_id
    if connection_layer_id > term_layer_id
      term.layer_id = connection_layer_id 
      AlnTermination.update_layer_ids_for_network(term_layer_id, connection_layer_id, term.get_network_id) if update_all
    elsif connection_layer_id < term_layer_id
      self.aln_termination_set.aln_terminations.each {|t| t.layer_id = term_layer_id}
      AlnTermination.update_layer_ids_for_network(connection_layer_id, term_layer_id, self.aln_termination_set.aln_terminations.first.network_id) if update_all
    end
  end

  ####################################################################################
  # class methods
  class << self

  end

end
