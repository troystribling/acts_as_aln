class AppMain < ActiveRecord::Base
  
  ###############################################################
  #### declare ancestor association with aln_resource
  ###############################################################
  has_ancestor :named => :inventory_item    

  ###############################################################
  #### declare supported association with app_main_component
  ###############################################################
  acts_as_supporter :of => :app_main_component

end
