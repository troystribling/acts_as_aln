class Server < ActiveRecord::Base

  ###############################################################
  #### declare ancestor association with inventory_item
  ###############################################################
   has_ancestor :named => :inventory_item     

  ###############################################################
  #### declare supported association with server_component
  ###############################################################
  acts_as_supporter :of => :server_component

end
