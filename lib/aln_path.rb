class AlnPath < ActiveRecord::Base

   ###############################################################
   #### declare descendant associations and ancestor association
   #### with aln_resource
   ###############################################################
   has_descendants
   has_ancestor :named => :aln_termination_set   

  ####################################################################################
  # class methods
  class << self
            
  end

end
