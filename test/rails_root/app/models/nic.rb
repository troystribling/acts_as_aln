class Nic < ActiveRecord::Base
  
  ###############################################################
  #### declare ancestor association with inventory_item
  ###############################################################
  has_ancestor :named => :inventory_item     

  ###############################################################
  #### declare supported association ethernet_termination
  ###############################################################
  acts_as_supporter :of => :ethernet_termination

end
