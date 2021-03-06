require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established where the terminations are not involved in a connection or other support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1])
    @server << @nic 
  end

  after(:each) do
    @server.destroy
  end

  it "should be nil for termination prior to establishment of support relationship" do 
    EthernetTermination.new(model_data[:ethernet_termination_1]).network_id.should be_nil
  end

  it "should be nil after support relationship is established" do
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    @nic << eth   
    check_network_id(EthernetTermination, eth.id, nil)
  end

end

##########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established where the terminations are not involved in a connection but either or both may be in other prior support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic 
  end

  after(:each) do
    @server.destroy
  end
  
  it "should be network_id of supporter when supporter is not in a prior support relationship with an aln_termination descendant and supported is not in a prior support relationship with an aln_termination descendant" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relationships
    @nic << eth    
    eth << ip

    #### check network_ids
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip.id, eth.network_id)

  end

  it "should be network_id of supporter when supporter is not in a prior supporting relationship with an aln_termination descendant and supported is in a prior support relationship with an aln_termination descendant" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support root relationship
    @nic << eth    

    #### create termination support relationship
    ip << tcp

    #### check supported network_ids
    check_network_id(IpTermination, ip.id, ip.network_id)
    check_network_id(TcpSocketTermination, tcp.id, ip.network_id)

    #### add supported network to support root
    eth.add_network(ip)

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
 
    #### check support root network_id
    check_network_id(IpTermination, ip.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp.id, eth.network_id)

  end

  it "should be network ID of supporter when supporter is in a prior supporting relationship with an aln_termination descendant and supported is not in a prior support relationship with an aln_termination descendant" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support root relationship
    @nic << eth    

    #### create supported relationship
    eth << ip1

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    #### check supported network_id
    check_network_id(IpTermination, ip1.id, eth.network_id)

    #### create second support relationship
    eth << ip2

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.network_id)

    #### check supported network_ids
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)

  end

  it "should be network ID of supporter when supporter is in a prior supporting relationship with an aln_termination descendant and supported in a prior support relationship with an aln_termination descendant" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support root relationship
    @nic << eth
    eth << ip1    

    #### create supported relationship
    ip2 << tcp

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    #### check supported network_id
    check_network_id(IpTermination, ip2.id, ip2.network_id)
    check_network_id(TcpSocketTermination, tcp.id, ip2.network_id)

    #### add supported network to support root
    eth.add_network(ip2)

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.network_id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp.id, eth.network_id)
    
  end

end

##########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established if supporter terminations are in a connection but neither are in other prior support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @server << [@nic1, @nic2, @nic3]
    @ethc = AlnConnection.new(:name => 'ethernet_connection', :termination_type => 'EthernetTermination')
    @ipc = AlnConnection.new(:name => 'ip_connection', :termination_type => 'IpTermination')
  end

  after(:each) do
    @server.destroy
    @ethc.destroy
    @ipc.destroy
  end
  
  it "should be network ID of supporter when supporter is in a prior connection and supported is not in a prior connection" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip = IpTermination.new(model_data[:ip_termination_1])
    ip.save

    #### create nonterminating support relationships
    @nic1 << eth1
    @nic2 << eth2
        
    #### create connections
    @ethc << [eth1, eth2]
    
    #### check network_id prior creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip.id, nil)
    
    #### create support relationship
    eth2 << ip

    #### check network_id after creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip.id, eth1.network_id)
    
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established if supporter terminations are in a connection and either are in other prior support relations with terminations" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @server << [@nic1, @nic2, @nic3]
    @ethc = AlnConnection.new(:name => 'ethernet_connection', :termination_type => 'EthernetTermination')
    @ipc = AlnConnection.new(:name => 'ip_connection', :termination_type => 'IpTermination')
  end

  after(:each) do
    @server.destroy
    @ethc.destroy
    @ipc.destroy
  end
  
  it "should be network ID of supporter when supporter is in a prior connection and support relationship with terminations and supported is not in a prior connection or support relationship with terminations" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    ip3.save

    #### create nonterminating support relationships
    @nic1 << eth1
    @nic2 << eth2

    #### create connections
    @ethc << [eth1, eth2]

    #### terminating support relationships
    eth1 << ip1
    eth2 << ip2
            
    #### check network_id prior creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(IpTermination, ip2.id, eth1.network_id)
    check_network_id(IpTermination, ip3.id, nil)
    
    #### create support relationship
    eth2.add_network(ip3)

    #### check network_id after creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(IpTermination, ip2.id, eth1.network_id)
    check_network_id(IpTermination, ip3.id, eth1.network_id)

  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship with terminations and supported is not in a prior connection but is in a prior support relationship with terminations" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    ip3 = IpTermination.new(model_data[:ip_termination_3])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create nonterminating support relationships
    @nic1 << eth1
    @nic2 << eth2

    #### create connections
    @ethc << [eth1, eth2]

    #### terminating support relationships
    eth1 << ip1
    eth2 << ip2
    ip3 << tcp
            
    #### check network_id prior creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(IpTermination, ip2.id, eth1.network_id)
    check_network_id(IpTermination, ip3.id, ip3.network_id)
    check_network_id(TcpSocketTermination, tcp.id, ip3.network_id)
    
    #### create support relationship
    eth2.add_network(ip3)

    #### check network_id after creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(IpTermination, ip2.id, eth1.network_id)
    check_network_id(IpTermination, ip3.id, eth1.network_id)
    check_network_id(TcpSocketTermination, tcp.id, eth1.network_id)

  end

end
