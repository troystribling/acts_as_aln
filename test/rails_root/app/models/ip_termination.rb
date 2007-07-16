class IpTermination < ActiveRecord::Base

  ###############################################################
  #### declare ancestor association with aln_termination
  ###############################################################
  has_ancestor :named => :aln_termination     

  ###############################################################
  #### declare supported association ethernet_termination
  ###############################################################
  acts_as_supporter :of => :tcp_socket_termination

end
