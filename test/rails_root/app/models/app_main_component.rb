class AppMainComponent < ActiveRecord::Base
  
  ###############################################################
  #### declare descendant associations and ancestor association
  #### with aln_resource
  ###############################################################
  has_ancestor :named => :aln_resource   

end

