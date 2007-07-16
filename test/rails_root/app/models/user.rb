class User < ActiveRecord::Base
  
  ###############################################################
  #### declare ancestor association with inventory_item
  ###############################################################
  has_ancestor :named => :aln_resource    

  ###############################################################
  #### declare supported association user_termination
  ###############################################################
  acts_as_supporter :of => :user_termination

end
