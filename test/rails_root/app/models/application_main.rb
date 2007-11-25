class ApplicationMain < ActiveRecord::Base
  
  ###############################################################
  #### declare ancestor association with aln_resource
  ###############################################################
  has_ancestor :named => :inventory_item    

end
