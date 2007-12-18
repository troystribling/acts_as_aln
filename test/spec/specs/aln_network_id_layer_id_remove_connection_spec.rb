require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "assigned network ID and layer ID for terminations after deatching from a connection where the terminations are not involved in another connection and may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @hw2 = HardwareComponent.new(model_data[:hardware_component_2])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @server << [@nic1 , @hw2]
    @hw2 << @nic2 
    @cip = AlnConnection.new(:resource_name => 'ip-connection', :termination_type => :ip_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
  end

  it "should have network ID of disconnected termination aln_termination_id for disconnected network, network ID of original network should not change and disconnected network should have maximum layer ID of 0 and original network should have maximum layer ID of 1 if disconnected network has no supported terminations and original network has supported terminations" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

    #### detach from network
    @cip.detach_network(ip2)

    #### validate removal from connection
    @cip.aln_terminations.should_not include(ip2)
    ip2.should_not be_in_connection
    
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

  end

  it "should have network ID of disconnected termination aln_termination_id for disconnected network, network ID of original network should not change and disconnected network should have maximum layer ID of 1 while original network should have maximum layer ID of 1 if both networks have supported terminations" do 

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

    #### detach from network
    @cip.detach_network(ip2)

    #### validate removal from connection
    @cip.aln_terminations.should_not include(ip2)
    ip2.should_not be_in_connection
    
    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)

    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp1.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip2.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)

  end
  
end

#########################################################################################################
describe "assigned network ID and layer ID for terminations after deatching from a connection where the terminations are involved in connections with more than 1 other termination and may have supported" do

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
    @cip = AlnConnection.new(:resource_name => 'ip-connection', :termination_type => :ip_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
  end

  it "should have network ID of disconnected termination aln_termination_id for disconnected network, network ID of original network should not change and disconnected network should have maximum layer ID of 0 while original network should have maximum layer ID of 1 if disconnected network has no supported terminations and original network has supported terminations" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(IpTermination, ip3.id, eth.network_id)

    #### validate initial configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)

    #### detach from network
    @cip.detach_network(ip2)

    #### validate removal from connection
    @cip.aln_terminations.should_not include(ip2)
    ip2.should_not be_in_connection
    
    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip3.id, nil)

    check_termination_supporter_id(IpTermination, ip2.id, nil)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip3.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)

    check_layer_id(IpTermination, ip2.id, 0)

  end

  it "should have network ID of disconnected termination aln_termination_id for disconnected network, network ID of original network should not change and disconnected network should have maximum layer ID of 1 and original network network should have maximum layer ID of 1 if both networks have supported terminations" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
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

    #### detach from network
    @cip.detach_network(ip3)

    #### validate removal from connection
    @cip.aln_terminations.should_not include(ip3)
    ip3.should_not be_in_connection
    
    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)

    check_termination_supporter_id(IpTermination, ip3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip3.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip3.aln_termination.id)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)

    check_network_id(IpTermination, ip3.id, ip3.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp1.id, ip3.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip3.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

    check_layer_id(IpTermination, ip3.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)

  end
  
end

###########################################################################################################
describe "assigned network ID and layer ID for terminations after deatching from a connection where supported terminations have 1 connection at the IP layer and 2 connections at the TCP layer" do

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
    @cip1 = AlnConnection.new(:resource_name => 'ip-connection-1', :termination_type => :ip_termination)
    @cip2 = AlnConnection.new(:resource_name => 'ip-connection-2', :termination_type => :ip_termination)
    @ctcp1 = AlnConnection.new(:resource_name => 'tcp-connection-1', :termination_type => :tcp_socket_termination)
    @ctcp2 = AlnConnection.new(:resource_name => 'tcp-connection-2', :termination_type => :tcp_socket_termination)
  end

  after(:each) do
    @server.destroy
    @cip1.destroy
    @cip2.destroy
    @ctcp1.destroy
    @ctcp2.destroy
  end

  it "should have network ID of disconnected termination aln_termination_id for disconnected network, network ID of original network should not change and disconnected network should have maximum layer ID of 1 while original network should have maximum layer ID of 1 if termination is removed from connection in IP layer" do 

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

    #### detach from network
    @cip1.detach_network(ip2)

    #### validate removal from connection
    @cip1.aln_terminations.should_not include(ip2)
    ip2.should_not be_in_connection

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)

    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, nil)

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp1.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, ip2.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)
    check_layer_id(TcpSocketTermination, tcp3.id, 1)
    check_layer_id(TcpSocketTermination, tcp4.id, 1)

  end

  it "should have network ID of disconnected termination aln_termination_id for disconnected network, network ID of original network should not change and disconnected network should have maximum layer ID of 0 while original network should have maximum layer ID of 2 if termination is removed from connection in IP layer" do 

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

    #### detach from network
    @ctcp2.detach_network(tcp3)

    #### validate removal from connection
    @ctcp2.aln_terminations.should_not include(tcp3)
    tcp3.should_not be_in_connection

    #### validate final termination supporter
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip2.aln_termination.id)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, nil)

    check_termination_supporter_id(TcpSocketTermination, tcp3.id, nil)

    #### validate final configuration network id 
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, eth.network_id)

    check_network_id(TcpSocketTermination, tcp3.id, tcp3.aln_termination.id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

    check_layer_id(TcpSocketTermination, tcp3.id, 0)

  end
  
end

############################################################################################################
describe "assigned network ID and layer ID for terminations after deatching from a connection where supported terminations have 2 connection at the IP layer and 2 connections at the TCP layer" do

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
    @cip1 = AlnConnection.new(:resource_name => 'ip-connection-1', :termination_type => :ip_termination)
    @cip2 = AlnConnection.new(:resource_name => 'ip-connection-2', :termination_type => :ip_termination)
    @ctcp1 = AlnConnection.new(:resource_name => 'tcp-connection-1', :termination_type => :tcp_socket_termination)
    @ctcp2 = AlnConnection.new(:resource_name => 'tcp-connection-2', :termination_type => :tcp_socket_termination)
  end

  after(:each) do
    @server.destroy
    @cip1.destroy
    @cip2.destroy
    @ctcp1.destroy
    @ctcp2.destroy
  end

  it "should have network ID of disconnected termination aln_termination_id for disconnected network, network ID of original network should not change and disconnected network should have maximum layer ID of 2 while original network should have maximum layer ID of 1 if termination is removed from connection in IP layer" do 

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
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
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

    #### detach from network
    @cip1.detach_network(ip2)

    #### validate removal from connection
    @cip1.aln_terminations.should_not include(ip2)
    ip2.should_not be_in_connection

    #### validate final termination supporter
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

    #### validate final configuration network id
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_network_id(EthernetTermination, eth4.id, ip2.network_id)
    check_network_id(IpTermination, ip3.id, ip2.network_id)
    check_network_id(IpTermination, ip4.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, ip2.network_id)

    #### validate final configuration layer id
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    check_layer_id(EthernetTermination, eth4.id, 0)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(IpTermination, ip4.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

  end

  it "should leave all termination in same network and maximum layer ID of network should not change" do 

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
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
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

    #### detach from network
    @ctcp2.detach_network(tcp3)
    ip3.reload

    #### validate removal from connection
    @ctcp2.aln_terminations.should_not include(tcp3)
    tcp3.should_not be_in_connection

    #### validate final termination supporter
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

    #### validate final configuration network id 
    check_network_id(IpTermination, ip3.id, ip3.aln_termination.id)
    check_network_id(EthernetTermination, eth1.id, ip3.network_id)
    check_network_id(EthernetTermination, eth4.id, ip3.network_id)
    check_network_id(IpTermination, ip1.id, ip3.network_id)
    check_network_id(IpTermination, ip2.id, ip3.network_id)
    check_network_id(IpTermination, ip4.id, ip3.network_id)
    check_network_id(TcpSocketTermination, tcp1.id, ip3.network_id)
    check_network_id(TcpSocketTermination, tcp2.id, ip3.network_id)
    check_network_id(TcpSocketTermination, tcp3.id, ip3.network_id)
    check_network_id(TcpSocketTermination, tcp4.id, ip3.network_id)

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

  end

end
