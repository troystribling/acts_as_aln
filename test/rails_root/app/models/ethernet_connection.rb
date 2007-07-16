class AlnEthernetConnection < ActiveRecord::Base

  ###############################################################
  #### declare ancestor association with aln_connection
  ###############################################################
  has_ancestor :named => :aln_connection     
  
end
