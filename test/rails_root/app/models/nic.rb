class Nic < ActiveRecord::Base
  
  ###############################################################
  #### declare ancestor association with inventory_item
  ###############################################################
  has_ancestor :named => :inventory_item     

end
