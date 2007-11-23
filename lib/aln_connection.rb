class AlnConnection < ActiveRecord::Base

  ###############################################################
  #### declare descendant associations and ancestor association
  #### with aln_resource
  ###############################################################
  has_descendants
  has_ancestor :named => :aln_termination_set   

  ####################################################################################
  #### add termination to connection
  def initialize(*args)
    super(*args)
    raise(ArgumentError, ":connected_termination_type must be specified") if args[0][:connected_termination_type].nil?
  end

  ####################################################################################
  #### add termination to connection
  def << (term)    
    validate_termination(term)
    set_first_network_id = lambda do |t| 
      t.get_network_id 
      self.aln_termination_set.aln_terminations << AlnTermination.to_aln_termination(t)
    end
    set_network_id = lambda do |t| 
      t.network_id = self.aln_termination_set.aln_terminations.first.network_id 
      t.layer_id = self.aln_termination_set.aln_terminations.first.layer_id 
      t.save
      self.aln_termination_set.aln_terminations << AlnTermination.to_aln_termination(t)
    end
    if self.aln_terminations.empty?
      if term.class.eql?(Array) 
        set_first_network_id[term.shift]
        term.each{|t| set_network_id[t]} 
      else
        set_first_network_id[term]
      end
    else
      term.class.eql?(Array) ? term.each{|t| set_network_id[t]} : set_network_id[term]
    end
    self.save
  end  

  ####################################################################################
  #### add network to connection
  def add_network (term)
    validate_termination(term)
    unless self.aln_terminations.empty? 
      old_network_id = term.get_network_id
      new_network_id = self.aln_termination_set.aln_terminations.first.network_id
      term.network_id = new_network_id 
      AlnTermination.update_all("network_id = #{new_network_id}", "network_id = #{old_network_id}")
    else
      term.get_network_id 
    end     
    self.aln_termination_set.aln_terminations << AlnTermination.to_aln_termination(term)
    self.save
  end  

  ####################################################################################
  #### validate termination class
  def validate_termination(term)
    check_termination = lambda do |t| 
      raise(PlanB::InvalidClass, "connected termination must be #{self.connected_termination_type.to_s}") unless t.class.name.tableize.singularize.to_sym.eql?(self.connected_termination_type)
      raise(PlanB::TerminationInvalid, "termination is already in connection") unless t.aln_termination_set_id.nil?
    end
    term.class.eql?(Array) ? term.each{|t| check_termination[t]} : check_termination[term]
  end

end
