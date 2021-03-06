require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "assignement of layer ID for a termination when a support relationship is established with a nonterminating aln_resource where the termination is not involved in a connection or other support relations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic
  end

  after(:each) do
    @server.destroy
  end

  it "should be 0 for termination prior to establishment of support relationship" do 
    EthernetTermination.new(model_data[:ethernet_termination_1]).layer_id.should eql(0)
  end

  it "should be 0 for termination after to establishment of support relationship" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])

    #### create support relations
    @nic << eth   

    #### verify layer_id of final configuration
    check_layer_id(EthernetTermination, eth.id, 0)

  end

  it "should be 0 for after another termination support relation is added to resource" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])

    #### create support relations
    @nic << [eth1, eth2]   

    #### verify layer_id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)

  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a support relationship is established where none of the terminations are involved in a connection and the added supported are not involved in other support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic
  end

  after(:each) do
    @server.destroy
  end

  it "should increase from 0 to 1 when first termination supported is added" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip = IpTermination.new(model_data[:ip_termination_1])
    ip.save

    #### create initial support relationship with nonterminating resouces    
    @nic << [eth1, eth2]   
    
    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip.id, 0)
    
    #### create support relationship with terminations
    eth1 << ip
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip.id, 1)

  end

  it "should remain 1 when another termination supported is aded" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip2.save

    #### create initial support relationship with nonterminating resouces    
    @nic << [eth1, eth2]   
    
    #### create initial support relationship with terminating resouces    
    eth1 << ip1

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 0)

    #### create support relationship with terminations
    eth1 << ip2
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

  end

  it "should remain 1 when another supported is added to a different termination with the same layer ID" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    ip3.save

    #### create initial support relationship with nonterminating resouces    
    @nic << [eth1, eth2]   
    
    #### create initial support relationship with terminating resouces    
    eth1 << [ip1, ip2]
    
    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 0)

    #### create support relationship with terminations
    eth2 << ip3
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)

  end

  it "should increase to 2 when another supported is added to a leaf termination of a network with maximum layer of 1" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])
    tcp.save

    #### create initial support relationship with nonterminating resouces    
    @nic << [eth1, eth2]   
    
    #### create initial support relationship with terminating resouces    
    eth1 << [ip1, ip2]
    eth2 << ip3
    
    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 0)

    #### create support relationship with terminations
    ip3 << tcp
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 2)

  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a support relationship is established where the terminations are involved in a connection and the added supported are not involved support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @server << [@nic1, @nic2]
    @c = AlnConnection.new(:name => 'ethernet_connection', :termination_type => 'EthernetTermination')
  end

  after(:each) do
    @server.destroy
    @c.destroy
  end

  it "should increase from 0 to 1 when first termination supported is added" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip = IpTermination.new(model_data[:ip_termination_1])
    ip.save

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1
    @nic2 << eth2   
    
    #### create initial connection between terminations
    @c << [eth1, eth2]    
    
    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip.id, 0)
    
    #### create support relationship with terminations
    eth1 << ip
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip.id, 1)

  end

  it "should remain 1 when another termination supported is aded" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip2.save

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1
    @nic2 << eth2   
    
    #### create initial connection between terminations
    @c << [eth1, eth2]    
    
    #### create initial support relationship with terminating resouces    
    eth1 << ip1

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 0)

    #### create support relationship with terminations
    eth1 << ip2
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

  end

  it "should remain 1 when another supported is added to a different termination with the same layer ID" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    ip3.save

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1
    @nic2 << eth2   
    
    #### create initial connection between terminations
    @c << [eth1, eth2]    
    
    #### create initial support relationship with terminating resouces    
    eth1 << [ip1, ip2]

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 0)

    #### create support relationship with terminations
    eth2 << ip3
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)

  end

  it "should increase to 2 when another supported is added to a leaf termination of a network with maximum layer of 1" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])
    tcp.save

    #### create initial support relationship with nonterminating resouces    
    @nic1 << eth1
    @nic2 << eth2   
    
    #### create initial connection between terminations
    @c << [eth1, eth2]    
    
    #### create initial support relationship with terminating resouces    
    eth1 << [ip1, ip2]
    eth2 << ip3

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 0)

    #### create support relationship with terminations
    ip3 << tcp
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(IpTermination, ip3.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 2)

  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a support relationship is established where the terminations are not involved in a connection but the added supported terminations are involved in prior support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic
  end

  after(:each) do
    @server.destroy
  end

  it "should increase from 0 to 2 when first supported termination is added if it has a single layer of supported" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip = IpTermination.new(model_data[:ip_termination_1])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])

    #### create initial support relationship with nonterminating resouces    
    @nic << [eth1, eth2]   
        
    #### create added supported network relationship with terminating resouces    
    ip << [tcp1, tcp2]

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip.id, 0)
    check_layer_id(TcpSocketTermination, tcp1.id, 1)
    check_layer_id(TcpSocketTermination, tcp2.id, 1)

    #### create support relationship with supporter network
    eth1.add_network(ip)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)

  end

  it "should remain 2 when another supported termination is addd with only a single layer of supported" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])
    tcp4 = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])

    #### create initial support relationship with nonterminating resouces    
    @nic << [eth1, eth2]   
        
    #### create supporter network relationship with terminating resouces
    eth1 << ip1    
    ip1 << [tcp1, tcp2]

    #### create added supported network relationship with terminating resouces    
    ip2 << [tcp3, tcp4]

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp3.id, 1)
    check_layer_id(TcpSocketTermination, tcp4.id, 1)

    #### create support relationship with supporter network
    eth1.add_network(ip2)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

  end

  it "should remain 2 when supported termination is added with a single layer of supported to another termination with the same layer ID bur no supported" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    tcp2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    tcp3 = TcpSocketTermination.new(model_data[:tcp_socket_termination_3])
    tcp4 = TcpSocketTermination.new(model_data[:tcp_socket_termination_4])

    #### create initial support relationship with nonterminating resouces    
    @nic << [eth1, eth2]   
        
    #### create supporter network relationship with terminating resouces
    eth1 << ip1    
    ip1 << [tcp1, tcp2]

    #### create added supported network relationship with terminating resouces    
    ip2 << [tcp3, tcp4]

    #### verify layer id of initial configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp3.id, 1)
    check_layer_id(TcpSocketTermination, tcp4.id, 1)

    #### create support relationship with supporter network
    eth2.add_network(ip2)
    
    #### verify layer id of final configuration
    check_layer_id(EthernetTermination, eth1.id, 0)
    check_layer_id(EthernetTermination, eth2.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp1.id, 2)
    check_layer_id(TcpSocketTermination, tcp2.id, 2)
    check_layer_id(TcpSocketTermination, tcp3.id, 2)
    check_layer_id(TcpSocketTermination, tcp4.id, 2)

  end

end
