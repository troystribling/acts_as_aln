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
  def descendant_initialize(*args)
    raise(ArgumentError, ":termination_type must be specified") if args[0][:termination_type].nil?
  end

  ####################################################################################
  #### validate termination class
  def validate_termination(term)
    check_termination = lambda do |t| 
      raise(PlanB::InvalidClass, "termination must be #{self.termination_type.to_s}") unless t.class.name.tableize.singularize.to_sym.eql?(self.termination_type)
      raise(PlanB::TerminationInvalid, "termination is already in set") unless t.aln_termination_set_id.nil?
    end
    term.class.eql?(Array) ? term.each{|t| check_termination[t]} : check_termination[term]
  end

  ####################################################################################
  # class methods
  class << self

    #### return model aln_termination
    def to_aln_termination_set(mod)
      mod.class.eql?(AlnTerminationSet) ? mod : mod.aln_termination_set
    end
          
  end

end


