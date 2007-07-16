class EthernetTermination < ActiveRecord::Base

  ###############################################################
  #### declare ancestor association with aln_termination
  ###############################################################
  has_ancestor :named => :aln_termination     

  ###############################################################
  #### declare supported association ip_termination
  ###############################################################
  acts_as_supporter :of => :ip_termination
  
end
