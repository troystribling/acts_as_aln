require File.dirname(__FILE__) + '/test_helper'

class AlnTerminationTest < Test::Unit::TestCase

  include TestCreateModelHelper 
  
  #### test resource_descendants
  def test_termination_new
#    ipt = IpTermination.new(:name => 'ETH 1', :ip_addr => '10.10.10..1')   
#    assert_equal('ETH 1', ipt.name, 'AlnThing#name from IpTermination failed')
#    assert_equal('10.10.10..1', ipt.ip_addr, 'IpTermination#ip_addr from IpTermination failed')
#    et = EthernetTermination.new(:name => 'External', :mac_addr => 'aa:bb:cc:dd:ee')   
#    assert_equal('External', et.name, 'AlnThing#name from EthernetTermination failed')
#    assert_equal('aa:bb:cc:dd:ee', et.mac_addr, 'EthernetTermination#mac_addr from EthernetTermination failed')
  end

  ###########################################################################################
  #### test creation of support hierarchy
  ###########################################################################################
  def test_resource_support_hierarchy_creation
  end

  ###########################################################################################
  #### test destruction of support hierarchy
  ###########################################################################################
  def test_resource_support_hierarchy_destroy
  end

end
