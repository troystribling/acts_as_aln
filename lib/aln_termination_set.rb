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
    validate_termination_class(term)
    set_network_id = lambda do |t| 
      t.network_id = self.aln_terminations.first.network_id 
      self.aln_terminations << t
      t.save
    end
    if self.aln_terminations.empty?
      if term.class.eql?(Array) 
        term.shift.get_network_id
        term.each{|t| set_network_id[t]} 
      else
        term.get_network_id
      end
    else
      term.class.eql?(Array) ? term.each{|t| set_network_id[t]} : set_network_id[term]
    end
  end  

  ####################################################################################
  #### validate termination class
  def validate_termination_class(term)
    check_termination = lambda{|t| raise(PlanB::InvalidClass, "target model is invalid") unless t.class.name.tableize.singularize.to_sym.eql?(self.connected_termination_type)}
    term.class.eql?(Array) ? term.each{|t| check_termination[t]} : check_termination[term]
  end

  ####################################################################################
  #### add network 
  def add_network (sup)
  end  

end
