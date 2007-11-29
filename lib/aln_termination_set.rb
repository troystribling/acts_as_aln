module AlnTerminationSet

  ####################################################################################
  #### validate termination class
  def validate_termination(term)
    check_termination = lambda do |t| 
      raise(PlanB::InvalidClass, "termination must be #{self.termination_type.to_s}") unless t.class.name.tableize.singularize.to_sym.eql?(self.termination_type)
      raise(PlanB::TerminationInvalid, "termination is already in set") unless t.aln_termination_set_id.nil?
    end
    term.class.eql?(Array) ? term.each{|t| check_termination[t]} : check_termination[term]
  end

end


