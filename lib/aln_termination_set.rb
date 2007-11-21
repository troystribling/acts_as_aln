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
  # class methods
  class << self

    #### return model aln_termination
    def to_aln_termination_set(mod)
      if mod.class.eql?(AlnTerminationSet)
        mod
      else
        mod.aln_termination_set
      end
    end
          
  end

end


