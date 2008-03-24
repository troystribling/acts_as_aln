module AlnTerminationHelper

  ####################################################################################
  #### validate termination class
  def validate_termination(term)
    raise(PlanB::InvalidClass, "termination must be #{self.termination_type.to_s}") unless term.class.name.eql?(self.termination_type)
    raise(PlanB::TerminationInvalid, "termination is already in #{self.class.name.tableize.singularize}") unless eval("term.#{self.class.name.tableize.singularize}_id.nil?")
    raise(PlanB::TerminationInvalid, "termination is in different support hierarchy") unless term.support_hierarchy_root_id.eql?(self.get_termination_support_hierarchy_root_id(term))
  end

  ####################################################################################
  #### remove terminations 
  ####################################################################################
  #### remove specified termination
  def remove_termination(term)
    do_remove = lambda do |t|
      term = AlnTermination.to_aln_termination(t)
      self.do_remove_from_termination(term)
      self.aln_terminations.to_ary.delete(term)
    end
    term.class.eql?(Array) ? term.each{|t| do_remove[t]} : do_remove[term]
  end
  
  ####################################################################################
  #### remove termination matching condition
  def remove_termination_if(&cond)
    self.aln_terminations.select(&cond).each{|t| self.do_remove_from_termination(t)}
    self.aln_terminations.to_ary.delete_if(&cond)
  end

  ####################################################################################
  #### remove all terminations
  def remove_all_terminations
    self.aln_terminations.each{|t| self.do_remove_from_termination(t)}
    self.aln_terminations.clear
  end

  ####################################################################################
  #### fetch termination attributes
  def get_termination_support_hierarchy_root_id (term)
    if self.aln_terminations.empty? 
      term.support_hierarchy_root_id
    else
      self.aln_terminations.first.support_hierarchy_root_id
    end  
  end
  
  ####################################################################################
  #### return termination as :termination_type
  def find_termination_as_type(*args)
    self.class.find_by_model_and_condition("aln_terminations.#{self.class.name.tableize.singularize}_id = #{self.id}", eval("#{self.termination_type.to_s.classify}"), *args)
  end
  
end


