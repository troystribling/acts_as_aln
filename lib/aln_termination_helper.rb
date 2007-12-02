module AlnTerminationHelper

  ####################################################################################
  #### remove termination without destroying
  def remove_termination(term)
    do_remove = lambda do |t|
      term = AlnTermination.to_aln_termination(t)
      self.aln_terminations.to_ary.delete(term)
    end
    term.class.eql?(Array) ? term.each{|t| do_remove[t]} : do_remove[term]
  end

  ####################################################################################
  #### remove termination matching condition without destroying
  def remove_termination_if(&cond)
    self.aln_terminations.to_ary.delete_if(&cond)
  end

  ####################################################################################
  #### remove all terminations
  def remove_all_terminations
    self.aln_terminations.to_ary.clear
  end

  ####################################################################################
  #### validate termination class
  def validate_termination(term)
    check_termination = lambda do |t| 
      raise(PlanB::InvalidClass, "termination must be #{self.termination_type.to_s}") unless t.class.name.tableize.singularize.to_sym.eql?(self.termination_type)
      raise(PlanB::TerminationInvalid, "termination is already in set") unless t.aln_connection_id.nil?
    end
    term.class.eql?(Array) ? term.each{|t| check_termination[t]} : check_termination[term]
  end

end


