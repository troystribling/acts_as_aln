require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "assigned network ID and layer ID for terminations after detaching from supporting relationship where the supported network terminations are not involved in a connection but may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic 
  end

  after(:each) do
    @server.destroy
  end
  
  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supported network and supporter network should have maximum layer ID of 0 if supported network and supporter have no supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relationships
    @nic << eth    
    eth << ip

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip.id, eth.network_id)

    #### validate initial configuration for network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip.id, eth.aln_termination.id)

    #### validate initial configuration for layer id 
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip.id, 1)

    #### detach from support hierarchy
    ip.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)

    check_termination_supporter_id(IpTermination, ip.id, nil)

    #### validate final configuration for network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    check_network_id(IpTermination, ip.id, ip.network_id)
    
    #### validate final configuration for layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip.id, 0)
    
    #### clean up
    ip.destroy
    
  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supported network should have maximum layer ID of 1 and supported maximum layer ID of 0 if supported network has supported but supporter has no supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support relationships
    @nic << eth 
    eth << ip   
    ip << tcp

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip.id, eth.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip.aln_termination.id)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 2)

    #### detach from support hierarchy
    ip.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)

    check_termination_supporter_id(IpTermination, ip.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    check_network_id(IpTermination, ip.id, ip.network_id)
    check_network_id(TcpSocketTermination, tcp.id, ip.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip.id, 0)
    check_layer_id(TcpSocketTermination, tcp.id, 1)

    #### clean up
    ip.destroy

  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supported network should have maximum layer ID of 0 and supporter network maximum layer ID of 1 if supported network has no supported and supporter network has supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support relationships
    @nic << eth    
    eth << [ip1, ip2]

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, eth.aln_termination.id)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)

    check_termination_supporter_id(IpTermination, ip2.id, nil)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    check_layer_id(IpTermination, ip2.id, 0)

    #### clean up
    ip2.destroy

  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supported network and supporter network should have maximum layer ID of 1 if supported network and supporter network have supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support relationships
    @nic << eth
    eth << [ip1, ip2]
    ip2 << tcp

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, eth.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip2.aln_termination.id)

    #### validate initial configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 2)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)

    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip2.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp.id, ip2.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp.id, 1)

    #### clean up
    ip2.destroy

  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supported netywork should have maximum layer ID of 1 and supported network maximum layer ID of 2 if supported network and supporter network have multiple supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])
    tcp4 = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])

    #### create support relationships
    @nic << eth
    eth << [ip1, ip2]
    ip1 << [tcp1, tcp2]
    ip2 << [tcp3, tcp4]

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, eth.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip1.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip1.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, ip2.aln_termination.id)

    #### validate initial configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip1.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip1.aln_termination.id)

    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, ip2.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, ip2.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)

    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp3.id, 1)
    check_layer_id(TcpSocketTermination, tcp4.id, 1)


    #### clean up
    ip2.destroy

  end

end

#########################################################################################################
describe "assigned network ID and layer ID for terminations after deatching from supporting relationship where the supported network terminations are involved in a connection with one termination and may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @hw2 = HardwareComponent.new(model_data[:hardware_component_2])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @server << [@nic1 , @hw2]
    @hw2 << @nic2 
    @cip = AlnConnection.new(:name => 'ip-connection', :termination_type => 'IpTermination')
  end

  after(:each) do
    @server.destroy
    @cip.destroy
  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supported network and supporter network should have maximum layer ID of 0 if supported and supporter network terminations have no supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support relationships
    @nic1.reload
    @nic1 << eth   
    eth << ip1
    @nic2.reload
    @nic2 << ip2
    
    #### create connection
    ip1.reload
    ip2.reload
    @cip << [ip1, ip2]

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

    #### detach from support hierarchy
    ip1.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)

    check_termination_supporter_id(IpTermination, ip1.id, nil)
    check_termination_supporter_id(IpTermination, ip2.id, nil)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    check_network_id(IpTermination, ip1.id, ip1.network_id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip1.id, 0)
    check_layer_id(IpTermination, ip2.id, 0)

    #### clean up
    ip1.destroy

  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supporter network should have maximum layer ID of 0 while supported network should have maximum layer ID of 1 if supported network terminations have supported and supporter network terminations do not have supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])

    #### create support relationships
    @nic1.reload
    @nic1 << eth    
    eth << ip1
    @nic2.reload
    @nic2 << ip2
    ip2 << [tcp1, tcp2]
        
    #### create connection
    ip1.reload
    ip2.reload
    @cip << ip1
    @cip.add_network(ip2)

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)

    #### detach from support hierarchy
    ip1.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)

    check_termination_supporter_id(IpTermination, ip1.id, nil)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    check_network_id(IpTermination, ip1.id, ip1.network_id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip1.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip1.id, 0)
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)

    #### clean up
    ip1.destroy

  end
  
end

##########################################################################################################
describe "assigned network ID and layer ID for terminations after deatching from supporting relationship where the supported network terminations are involved in connections with more than 1 other termination and may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @hw2 = HardwareComponent.new(model_data[:hardware_component_2])
    @hw3 = HardwareComponent.new(model_data[:hardware_component_3])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @server << [@nic1 , @hw2, @hw3]
    @hw2.reload
    @hw2 << @nic2 
    @hw3 << @nic3 
    @cip = AlnConnection.new(:name => 'ip-connection', :termination_type => 'IpTermination')
  end

  after(:each) do
    @server.destroy
    @cip.destroy
  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supporter network should have maximum layer ID of 0 while supported network should have maximum layer ID of 0 if supported and supporter network terminations have no supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])

    #### create support relationships
    @nic1.reload
    @nic1 << eth    
    eth << ip1
    @nic2.reload
    @nic2 << ip2
    @nic3.reload
    @nic3 << ip3
    
    #### create connection
    ip1.reload
    ip2.reload
    ip3.reload
    @cip << [ip1, ip2, ip3]

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(IpTermination, ip3.id, nil)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(IpTermination, ip3.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)

    #### detach from support hierarchy
    ip1.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)

    check_termination_supporter_id(IpTermination, ip1.id, nil)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(IpTermination, ip3.id, nil)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    check_network_id(IpTermination, ip1.id, ip1.network_id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)
    check_network_id(IpTermination, ip3.id, ip1.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip1.id, 0)
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(IpTermination, ip3.id, 0)

    #### clean up
    ip1.destroy

  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supporter network should have maximum layer ID of 0 while supported network should have maximum layer ID of 1 if supported network terminations have supported and supporter network terminations do not have terminations" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])

    #### create support relationships
    @nic1.reload
    @nic1 << eth    
    eth << ip1
    @nic2.reload
    @nic2 << ip2
    @nic3.reload
    @nic3 << ip3
    ip3 << [tcp1, tcp2]
    
    #### create connection
    ip1.reload
    ip2.reload
    ip3.reload
    @cip << [ip1, ip2]
    @cip.add_network(ip3)

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(IpTermination, ip3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip3.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip3.aln_termination.id)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(IpTermination, ip3.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)

    #### detach from support hierarchy
    ip1.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)

    check_termination_supporter_id(IpTermination, ip1.id, nil)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(IpTermination, ip3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip3.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip3.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    check_network_id(IpTermination, ip1.id, ip1.network_id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)
    check_network_id(IpTermination, ip3.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip1.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip1.id, 0)
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(IpTermination, ip3.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)

    #### clean up
    ip1.destroy

  end
  
end

##########################################################################################################
describe "assigned network ID and layer ID for terminations after deatching from supporting relationship where multiple supported network supported terminations at different layers are involved in connections with 1 other termination" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @hw2 = HardwareComponent.new(model_data[:hardware_component_2])
    @hw3 = HardwareComponent.new(model_data[:hardware_component_3])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @nic4 = Nic.new(model_data[:nic_4]) 
    @server << [@nic1 , @hw2, @hw3, @nic4]
    @hw2.reload
    @hw2 << @nic2 
    @hw3.reload
    @hw3 << @nic3 
    @cip1 = AlnConnection.new(:name => 'ip-connection-1', :termination_type => 'IpTermination')
    @cip2 = AlnConnection.new(:name => 'ip-connection-2', :termination_type => 'IpTermination')
    @ctcp1 = AlnConnection.new(:name => 'tcp-connection-1', :termination_type => 'TcpSocketTermination')
    @ctcp2 = AlnConnection.new(:name => 'tcp-connection-2', :termination_type => 'TcpSocketTermination')
  end

  after(:each) do
    @server.destroy
    @cip1.destroy
    @cip2.destroy
    @ctcp1.destroy
    @ctcp2.destroy
  end

  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supporter network should have maximum layer ID of 0 while supported network should have maximum layer ID of 1 if 1 connection exists in ip layer and two connections exist in tcp layer" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])
    tcp4 = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])

    #### create support relationships
    @nic1.reload
    @nic1 << eth    
    eth << ip1
    @nic2.reload
    @nic2 << ip2
    ip2 << [tcp1, tcp2]
    @nic3.reload
    @nic3 << [tcp3, tcp4]
    
    #### create connections
    ip1.reload
    ip2.reload
    @cip1 << ip1
    @cip1.add_network(ip2)
    tcp1.reload
    tcp4.reload
    @ctcp1 << [tcp1, tcp4]
    tcp2.reload
    tcp3.reload
    @ctcp2 << [tcp2, tcp3]

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, nil)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

    #### detach from support hierarchy
    ip1.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)

    check_termination_supporter_id(IpTermination, ip1.id, nil)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, nil)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    check_network_id(IpTermination, ip1.id, ip1.network_id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, ip1.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip1.id, 0)
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)
    check_layer_id(TcpSocketTermination, tcp3.id, 1)
    check_layer_id(TcpSocketTermination, tcp4.id, 1)

    #### clean up
    ip1.destroy

  end
  
  it "should have network ID of detached supported for supported network, network ID of supporter network should not change and supporter network should have maximum layer ID of 0 while supported network should have maximum layer ID of 1 if 2 connections exists in ip layer and two connections exist in tcp layer" do 

    #### create models
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth4 = EthernetTermination.new(model_data[:ethernet_termination_4])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    ip4 = IpTermination.new(model_data[:ip_termination_4])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])
    tcp4 = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])

    #### create support relationships
    @nic1.reload
    @nic1 << eth1    
    eth1 << ip1
    @nic4.reload
    @nic4 << eth4    
    eth4 << ip4
    @nic2.reload
    @nic2 << ip2
    ip2 << [tcp1, tcp2]
    @nic3.reload
    @nic3 << ip3
    ip3 << [tcp3, tcp4]
    
    #### create connections
    ip1.reload
    ip2.reload
    @cip1.add_network(ip1)
    @cip1.add_network(ip2)
    tcp1.reload
    tcp4.reload
    @ctcp1.add_network(tcp1)
    @ctcp1.add_network(tcp4)
    tcp2.reload
    tcp3.reload
    @ctcp2.add_network(tcp2)
    @ctcp2.add_network(tcp3)
    ip3.reload
    ip4.reload
    @cip2.add_network(ip3)
    @cip2.add_network(ip4)

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth1.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth1.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, ip3.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, ip3.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth4.id, nil)
    check_termination_supporter_id(IpTermination, ip4.id, eth4.aln_termination.id)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth4.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(IpTermination, ip2.id, eth1.network_id)
    check_network_id(IpTermination, ip3.id, eth1.network_id)
    check_network_id(IpTermination, ip4.id, eth1.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth1.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth1.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, eth1.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, eth1.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth4.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(IpTermination, ip4.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

    #### detach from support hierarchy
    ip1.detach_support_hierarchy

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth1.id, nil)

    check_termination_supporter_id(IpTermination, ip1.id, nil)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, ip3.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, ip3.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth4.id, nil)
    check_termination_supporter_id(IpTermination, ip4.id, eth4.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)

    check_network_id(IpTermination, ip1.id, ip1.network_id)
    check_network_id(EthernetTermination, eth4.id, ip1.network_id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)
    check_network_id(IpTermination, ip3.id, ip1.network_id)
    check_network_id(IpTermination, ip4.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, ip1.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, ip1.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth1.id, 0)

    check_layer_id(EthernetTermination, eth4.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(IpTermination, ip4.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

    #### clean up
    ip1.destroy

  end

end
