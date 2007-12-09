require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "assignement of layer ID for terminations when a connection is established where the terminations are not involved in a connection and are not involved support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @server << [@nic1, @nic2]
    @c = AlnConnection.new(:resource_name => 'ethernet_connection', :termination_type => :ethernet_termination)
  end

  after(:each) do
    @server.destroy
    @c.destroy
  end

  it "should be 0 for termination prior to establishment of connection" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])

    #### create support relationship with nonterminating resouces    
    @nic1 << eth  
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth.id, 0)

  end

  it "should be 0 for termination after establishment of connection" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])

    #### create support relationship with nonterminating resouces    
    @nic1 << eth   
    
    #### create connection
    @c << eth
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth.id, 0)

  end

  it "should be 0 after establishment of connection with another termination" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_1])

    #### create support relationship with nonterminating resouces    
    @nic1 << eth1   
    @nic2 << eth2   
    
    #### create connection
    @c << [eth1, eth2]
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)

  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a connection is established where the terminations are not involved in a connection but are involved support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @server << [@nic1, @nic2]
    @c = AlnConnection.new(:resource_name => 'ethernet_connection', :termination_type => :ethernet_termination)
  end

  after(:each) do
    @server.destroy
    @c.destroy
  end

  it "should be 1 for network when connection is established when connected termination is in a network with maximum layer ID of 1 and the connecting termination is in a network with maximum layer ID of 0" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1   
    @nic2 << eth2   
        
    #### create supporter network relationship with terminating resouces
    eth1 << ip1    

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    #### create connection
    @c << [eth1, eth2]
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

  end

  it "should be 1 for network when connection is established when connected termination is in a network with maximum layer ID of 1 and the connecting termination is in a network with maximum layer ID of 1" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1   
    @nic2 << eth2   
        
    #### create supporter network relationship with terminating resouces
    eth1 << ip1    
    eth2 << ip2    

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

    #### create connection
    @c << [eth1, eth2]
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

  end

  it "should be 1 for network when connection is established when connected termination is in a network with maximum layer ID of 0 and the connecting termination is in a network with maximum layer ID of 1" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1   
    @nic2 << eth2   
        
    #### create supporter network relationship with terminating resouces
    eth2 << ip1    

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

    #### create connection
    @c << [eth1, eth2]
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)

  end

end

##########################################################################################################
describe "assignement of layer ID for terminations when a connection is established at a supporting layer" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @application_main = ApplicationMain.new(model_data[:application_main_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @server << [@application_main, @nic2, @nic3]   
    @application_main << @nic1
    @cip = AlnConnection.new(:resource_name => 'ip_connection', :termination_type => :ip_termination)
    @ctcp = AlnConnection.new(:resource_name => 'tcp_connection', :termination_type => :tcp_socket_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
    @ctcp.destroy
  end

  it "should be 1 for network when connection is established when connected termination has layer ID of 1 and the connecting termination has layer ID of 1" do

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1   
    @nic2 << eth2   
        
    #### create supporter network relationship with terminating resouces
    eth1 << ip1    
    eth2 << ip2    

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

    #### create connection
    @cip.add_network(ip1) 
    @cip.add_network(ip2)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
     
  end

  it "should be 1 for network when connection is established when connected termination has layer ID of 0 and the connecting termination has layer ID of 1" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << ip1
    @nic2 << eth2   
        
    #### create supporter network relationship with terminating resouces
    eth2 << ip2    

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip1.id, 0)

    #### create connection
    @cip.add_network(ip1) 
    @cip.add_network(ip2)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

  end

  it "should be 2 for network when connection is established between networks when one has maximum layer ID of 1 and the other has maximum layer ID of 1" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << ip1
    @nic2 << eth2   
        
    #### create supporter network relationship with terminating resouces
    ip1 << tcp1
    eth2 << ip2    

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip1.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)

    #### create connection
    @cip.add_network(ip1)
    @cip.add_network(ip2)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)

  end

  it "should be 2 for network when connection is established between networks when one has maximum layer ID of 1 and the other has maximum layer ID of 1" do 

    #### create terminations
    eth3 = EthernetTermination.new(model_data[:ethernet_termination_3])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << tcp1
    @nic2 << ip2
    @nic3 << eth3   
        
    #### create supporter network relationship with terminating resouces
    ip2 << tcp2
    eth3 << ip3    
    
    #### create prior connections
    @ctcp.add_network(tcp2)
    @ctcp.add_network(tcp1)
    
    #### verify layer id of initial configuration
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)
    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)

    #### create connection
    @cip.add_network(ip2)
    @cip.add_network(ip3)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)

  end

end

##########################################################################################################
describe "assignement of layer ID for terminations when a connection is established as order terminations are added to connection is varied" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @application_main = ApplicationMain.new(model_data[:application_main_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @server << [@application_main, @nic2, @nic3]   
    @application_main << @nic1
    @cip = AlnConnection.new(:resource_name => 'ip_connection', :termination_type => :ip_termination)
    @ctcp = AlnConnection.new(:resource_name => 'tcp_connection', :termination_type => :tcp_socket_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
    @ctcp.destroy
  end

  it "should be identical when a connection established between two networks with different layer IDs (configuration 1)" do 

    #### create terminations
    eth3 = EthernetTermination.new(model_data[:ethernet_termination_3])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << tcp1
    @nic2 << ip2
    @nic3 << eth3   
        
    #### create supporter network relationship with terminating resouces
    ip2 << tcp2
    eth3 << ip3    
    
    #### create prior connections
    @ctcp.add_network(tcp2)
    @ctcp.add_network(tcp1)
    
    #### verify layer id of initial configuration
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)
    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)

    #### create connection
    @cip.add_network(ip2)
    @cip.add_network(ip3)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)

  end

  it "should be identical when a connection established between two networks with different layer IDs (configurtaion 2)" do 

    #### create terminations
    eth3 = EthernetTermination.new(model_data[:ethernet_termination_3])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << tcp1
    @nic2 << ip2
    @nic3 << eth3   
        
    #### create supporter network relationship with terminating resouces
    ip2 << tcp2
    eth3 << ip3    
    
    #### create prior connections
    @ctcp.add_network(tcp1)
    @ctcp.add_network(tcp2)
    
    #### verify layer id of initial configuration
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)
    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)

    #### reload model prior to building connection since some metadata was updated during privious operations
    ip2 = AlnTermination.find(ip2.aln_termination_id).to_descendant
    
    #### create connection
    @cip.add_network(ip3)
    @cip.add_network(ip2)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)

  end
  
end


##########################################################################################################
describe "assignement of layer ID for terminations when a connection is established at a supporting layer with more than two terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @application_main = ApplicationMain.new(model_data[:application_main_1])    
    @nic1 = Nic.new(model_data[:nic_1])
    @nic3 = Nic.new(model_data[:nic_3]) 
    @nic4 = Nic.new(model_data[:nic_4]) 
    @server << [@application_main, @nic1, @nic3]   
    @application_main << @nic4   
    @cip = AlnConnection.new(:resource_name => 'ip_connection', :termination_type => :ip_termination)
    @ctcp = AlnConnection.new(:resource_name => 'tcp_connection', :termination_type => :tcp_socket_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
    @ctcp.destroy
  end

  it "should be 2 for network when third connection is established when connected network has maximum layer ID of 1 and connecting network has maximum layer ID of 1" do 
  
    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])
    tcp4 = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])

    #### create initial support relationship with nonterminating resouces    
    @nic3 << ip3  
    @nic4 << tcp4
    @nic1 << [eth1, eth2]
        
    #### create supporter network relationship with terminating resouces
    eth1 << ip1    
    eth2 << ip2    
    ip3 << tcp3
    
    #### create prior connections
    @ctcp.add_network(tcp3)
    @ctcp.add_network(tcp4)
    @cip << [ip2, ip2]
    
    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    
    check_layer_id(IpTermination, ip3.id, 0)
    check_layer_id(TcpSocketTermination, tcp3.id, 1)
    check_layer_id(TcpSocketTermination, tcp4.id, 1)

    #### reload model prior to building connection since some metadata was updated during privious operations
    ip3 = AlnTermination.find(ip3.aln_termination_id).to_descendant

    #### create connection
    @cip.add_network(ip3)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)    
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)
    
  end

end

##########################################################################################################
describe "assignement of layer ID for terminations for a network with more than three layers" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @application_main = ApplicationMain.new(model_data[:application_main_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @server << [@application_main, @nic2, @nic3]   
    @application_main << @nic1
    @cip = AlnConnection.new(:resource_name => 'ip_connection', :termination_type => :ip_termination)
    @ctcp = AlnConnection.new(:resource_name => 'tcp_connection', :termination_type => :tcp_socket_termination)
    @ctp = AlnConnection.new(:resource_name => 'tp_connection', :termination_type => :aln_termination)
  end

  after(:each) do
    @server.destroy
    @cip.destroy
    @ctcp.destroy
    @ctp.destroy
  end

  it "should be 2 for network when connection is established between networks when one has maximum layer ID of 1 and the other has maximum layer ID of 1" do 

    #### create terminations
    eth3 = EthernetTermination.new(model_data[:ethernet_termination_3])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])
    tp1 = AlnTermination.new(model_data[:aln_termination_1])

    #### create initial support relationship with nonterminating resouces    
    @nic1 << tcp1
    @nic2 << ip2
    @nic3 << eth3   
        
    #### create supporter network relationship with terminating resouces
    tcp1 << tp1
    ip2 << tcp2
    eth3 << ip3    
    
    #### create prior connections
    @ctcp.add_network(tcp2)
    @ctcp.add_network(tcp1)
    
    #### verify layer id of initial configuration
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)
    check_layer_id(AlnTermination, tp1.id, 2)

    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)

    #### create connection
    @cip.add_network(ip2)
    @cip.add_network(ip3)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth3.id, 0)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(AlnTermination, tp1.id, 3)
    
  end

end

