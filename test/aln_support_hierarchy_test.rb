require File.dirname(__FILE__) + '/test_helper'

class AlnSupportHierarchyTest < Test::Unit::TestCase
  
  include TestCreateModelHelper 
  
  ###########################################################################################
  #### test creation of support hierarchy
  ###########################################################################################
  def test_resource_support_hierarchy_creation

    #### create support hierarchy and save
    build_support_hierarchy

  end

  ###########################################################################################
  #### test destruction of support hierarchy
  ###########################################################################################
  def test_resource_support_hierarchy_destroy
  end
  
      
end
