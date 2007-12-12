require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "assignement of network ID and layer ID for terminations after detaching from supporting relationship where the supported network terminations are not involved in a connection but may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic 
  end

  after(:each) do
    @server.destroy
  end
  
  it "should have network ID of aln_termination_id for supported network, network ID of supporter should not change and supported network and supporter should have maximum layer ID of 0 if supported network and supporter have no supported" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)

    check_network_id(IpTermination, ip.id, ip.aln_termination.id)
    
    #### validate final configuration for layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip.id, 0)
    
    #### clean up
    ip.destroy
    
  end

  it "should have network ID of aln_termination_id for supported network, network ID of supporter should not change and supported network should have maximum layer ID of 1 and supported maximum layer ID of 0 if supported network has supported but supporter has no supported" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)

    check_network_id(IpTermination, ip.id, ip.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp.id, ip.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip.id, 0)
    check_layer_id(TcpSocketTermination, tcp.id, 1)

    #### clean up
    ip.destroy

  end

  it "should have network ID of aln_termination_id for supported network, network ID of supporter should not change and supported should have maximum layer ID of 0 and supported maximum layer ID of 1 if supported network has no supported and supporter has supported" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    check_layer_id(IpTermination, ip2.id, 0)

    #### clean up
    ip2.destroy

  end

  it "should have network ID of aln_termination_id for supported network, network ID of supporter should not change and supported network and supporter should have maximum layer ID of 1 if supported and supporter have supported" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp.id, ip2.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp.id, 1)

    #### clean up
    ip2.destroy

  end

  it "should have network ID of aln_termination_id for supported network, network ID of supporter should not change and supported should have maximum layer ID of 1 and supported maximum layer ID of 2 if supported and supporter have multiple supported" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
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

##########################################################################################################
describe "assignement of network ID and layer ID for terminations after deatching from supporting relationship where the supported network terminations are involved in a connection with one termination and may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @hw2 = HarwareComponent.new(model_data[:hardware_component_2])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @server << [@nic1 , @hw2]
    @hw2 << nic2 
    @cip = AlnConnection.new(:resource_name => 'ip-connection', :termination_type => :ip_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
  end

  it "should have network ID of aln_termination_id for supported, network ID of supporter should not change and supported network and supporter should have maximum layer ID of 0 if supported network terminations have no supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support relationships
    @nic1 << eth    
    eth << ip1
    @nic2 << ip2
    
    #### create connection
    @cip << [ip1, ip2]

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)

    check_network_id(IpTermination, ip1.id, ip1.aln_termination.id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)

    check_layer_id(IpTermination, ip1.id, 0)
    check_layer_id(IpTermination, ip2.id, 0)

    #### clean up
    ip2.destroy

  end

  it "should have network ID of aln_termination_id for supported, network ID of supporter should not change and supporter should have maximum layer ID of 0 while supported network should have maximum layer ID of 1 if supported network terminations have supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])

    #### create support relationships
    @nic1 << eth    
    eth << ip1
    @nic2 << ip2
    ip2 << [tcp1, tcp2]
    
    #### create connection
    @cip << [ip1, ip2]

    #### validate initial termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)

    #### validate initial configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)

    check_network_id(IpTermination, ip1.id, ip1.aln_termination.id)
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
    ip2.destroy

  end
  
end

##########################################################################################################
describe "assignement of network ID and layer ID for terminations after deatching from supporting relationship where the supported network terminations are involved in connections with more than 1 other termination and may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @hw2 = HarwareComponent.new(model_data[:hardware_component_2])
    @hw3 = HarwareComponent.new(model_data[:hardware_component_3])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @server << [@nic1 , @hw2, @hw3]
    @hw2 << nic2 
    @hw3 << nic3 
    @cip = AlnConnection.new(:resource_name => 'ip-connection', :termination_type => :ip_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
  end


end
