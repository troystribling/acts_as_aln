class AlnConnection < ActiveRecord::Base

  ###############################################################
  #### mixins
  extend AlnHelper
  include AlnTerminationHelper
  
  ###############################################################
  #### declare descendant associations and ancestor association
  #### with aln_resource
  ###############################################################
  has_descendants
  has_ancestor :named => :aln_resource   

  ###############################################################
  #### declare termination associations with aln_terminations
  ###############################################################
  has_many :aln_terminations, :dependent => :nullify     
  
  ####################################################################################
  #### remove connection from termination
  def do_remove_from_termination (term)
    term.aln_connection_id = nil
    term.aln_connection = nil
    term.save
  end
      
  ####################################################################################
  #### add termination to connection
  def << (term)    
    add_first_term = lambda do |t| 
      self.validate_termination(t)    
      t.get_network_id 
      self.aln_terminations << AlnTermination.to_aln_termination(t)
    end
    add_term = lambda do |t| 
      self.validate_termination(t)    
      self.update_layer_id(t, false)
      t.network_id = self.aln_terminations.first.network_id 
      t.save
      self.aln_terminations << AlnTermination.to_aln_termination(t)
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

  #### add network to connection
  def add_network (term)
    self.validate_termination(term)
    unless self.aln_terminations.empty? 
      self.update_layer_id(term, true)
      connection_network_id = self.aln_terminations.first.network_id
      term_network_id = term.get_network_id
      term.network_id = connection_network_id
      AlnTermination.update_network_id(term_network_id, connection_network_id)
    else
      term.get_network_id 
    end     
    self.aln_terminations << AlnTermination.to_aln_termination(term)    
    self.save
  end  

  ####################################################################################
  #### update layer_id
  def update_layer_id (term, update_all)
    term_layer_id = term.layer_id
    connection_layer_id = self.aln_terminations.first.layer_id
    if connection_layer_id > term_layer_id
      term.layer_id = connection_layer_id 
      AlnTermination.update_layer_ids_for_network(connection_layer_id - term_layer_id, term.get_network_id) if update_all
    elsif connection_layer_id < term_layer_id
      self.aln_terminations.each {|t| t.layer_id = term_layer_id}
      AlnTermination.update_layer_ids_for_network(term_layer_id - connection_layer_id, self.aln_terminations.first.network_id) if update_all
    end
  end

  ####################################################################################
  #### destroy specified termination
  def destroy_termination(term)
    term.supported.empty? ? self.remove_termination(term) : self.detach_network(term)      
    term.destroy    
  end  

  #### detach network from connection
  def detach_network(term)
    self.remove_termination(term)
    term.find_root_termination_supporter.detach_network
  end  

  ####################################################################################
  #### return termination as :termination_type
  def find_termination_as_type(*args)
    self.class.find_by_model_and_condition("aln_terminations.aln_connection_id = #{self.id}", eval(self.termination_type.to_s.classify), *args)
  end

  ####################################################################################
  # class methods
  class << self
  end

end
