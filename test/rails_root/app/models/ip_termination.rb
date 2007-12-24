class IpTermination < ActiveRecord::Base

  ###############################################################
  #### declare ancestor association with aln_termination
  ###############################################################
  has_ancestor :named => :aln_termination     

end
