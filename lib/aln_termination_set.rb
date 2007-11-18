class AlnTerminationSet < ActiveRecord::Base

   ###############################################################
   #### declare descendant associations and ancestor association
   #### with aln_resource
   ###############################################################
   has_descendants
   has_ancestor :named => :aln_resource   

   ###############################################################
   #### declare termination associations with aln_terminations
   ###############################################################
   has_many :aln_terminations     

  ####################################################################################
  #### add termination to connection
  def << (term)    
    validate_termination(term)
    set_first_network_id = lambda do |t| 
      t.get_network_id 
      self.aln_terminations << AlnTermination.to_aln_termination(t)
    end
    set_network_id = lambda do |t| 
      t.network_id = self.aln_terminations.first.network_id 
      t.save
      self.aln_terminations << AlnTermination.to_aln_termination(t)
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
    self.aln_terminations.empty? ? term.get_network_id : \
      self.class.update_all("network_id = #{self.aln_terminations.first.network_id }", "network_id = #{term.get_network_id}")     
    self.aln_terminations << AlnTermination.to_aln_termination(term)
    self.save
  end  

  ####################################################################################
  #### validate termination class
  def validate_termination(term)
    check_termination = lambda{|t| raise(PlanB::InvalidClass, "target model is invalid") unless t.class.name.tableize.singularize.to_sym.eql?(self.connected_termination_type)}
    term.class.eql?(Array) ? term.each{|t| check_termination[t]} : check_termination[term]
  end

end

