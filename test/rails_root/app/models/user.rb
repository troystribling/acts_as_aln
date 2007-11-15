class User < ActiveRecord::Base
  
  ###############################################################
  #### declare ancestor association with inventory_item
  ###############################################################
  has_ancestor :named => :aln_resource    

end
