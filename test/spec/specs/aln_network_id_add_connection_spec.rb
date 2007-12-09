require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "assignement of network ID for terminations when added to a connection where the terminations are not involved in other prior connections or other prior support relations" do

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
  
  it "should be aln_termination_id of termination added to connection if no other terminations are in connection" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])

    #### create support relations
    @nic1 << eth
    
    #### create connection
    @c << eth
    
    #### check network_id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)

  end

  it "should be network ID of first termination as next termination is added to connection" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])

    #### create support relations
    @nic1 << eth1
    @nic2 << eth2

    #### create connection
    @c << [eth1, eth2]
    
    #### check network_id
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)

  end

end

#########################################################################################################
describe "assignement of network ID for terminations when termination hierarchy root is added to a connection if either or both terminations are involved in prior support relations with other terminations" do
  
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

  it "should be network ID of termination, which has a supported termination, as termination is added to connection that contains no prior terminations" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relations
    @nic1 << eth
    eth << ip
    
    #### check network_id prior to connection
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth.network_id)
    
    #### create connection
    @c.add_network(eth)
    
    #### check network_id after connection
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth.network_id)

  end

  it "should be network ID of first termination in connection, which has a supported termination, as termination with no supported terminations is added to connection" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relations
    @nic1 << eth1
    eth1 << ip
    @nic2 << eth2
    
    #### check network_id prior to connection
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, nil)
    
    #### create connection
    @c.add_network(eth1)
    @c << eth2
    
    #### check network_id after connection
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip.id, eth1.network_id)

  end

  it "should be network ID of first termination in connection, which has a supported termination, as termination with a supported is added to connection" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_1])

    #### create support relations
    @nic1 << eth1
    eth1 << ip1
    @nic2 << eth2
    eth2 << ip2
    
    #### check network_id prior to connection
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(EthernetTermination, eth2.id, eth2.aln_termination.id)
    check_network_id(IpTermination, ip2.id, eth2.network_id)
    
    #### create connection
    @c.add_network(eth1)
    @c.add_network(eth2)
    
    #### check network_id after connection
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(IpTermination, ip2.id, eth2.network_id)

  end

  it "should be network ID of first termination in connection, which has no supported terminations, as termination with a supported is added to connection" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relations
    @nic1 << eth1
    @nic2 << eth2
    eth2 << ip
    
    #### check network_id prior to connection
    check_network_id(EthernetTermination, eth1.id, nil)
    check_network_id(EthernetTermination, eth2.id, eth2.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth2.network_id)
    
    #### create connection
    @c << eth1
    @c.add_network(eth2)
    
    #### check network_id after connection
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip.id, eth1.network_id)

  end

end

##########################################################################################################
describe "assignement of network ID for terminations when termination supported is added to a connection" do
  
  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @server << [@nic1, @nic2]
    @ethc = AlnConnection.new(:resource_name => 'ethernet_connection', :termination_type => :ethernet_termination)
    @ipc = AlnConnection.new(:resource_name => 'ip_connection', :termination_type => :ip_termination)
  end

  after(:each) do
    @server.destroy
    @ethc.destroy
    @ipc.destroy
  end

  it "should be network ID of termination, which is a supported termination, as termination is added to connection that contains no prior terminations" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relations
    @nic1 << eth
    eth << ip
    
    #### check network_id prior to connection
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth.network_id)
    
    #### create connections
    @ethc.add_network(eth)
    @ipc.add_network(ip)
    
    #### check network_id after connection
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth.network_id)

  end

  it "should be network ID of first termination, which is a supported termination, as termination root is added to connection" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support relations
    @nic1 << eth
    eth << ip1
    @nic2 << ip2
    
    #### check network_id prior to connection
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, nil)
    
    #### create connections
    @ethc.add_network(eth)
    @ipc.add_network(ip1)
    @ipc.add_network(ip2)
    
    #### check network_id after connection
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)

  end

  it "should be network ID of first termination, which is a termination root, as supported termination is added to connection" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support relations
    @nic1 << ip1
    @nic2 << eth
    eth << ip2
    
    #### check network_id prior to connection
    check_network_id(IpTermination, ip1.id, nil)
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    
    #### create connections
    @ethc.add_network(eth)
    @ipc.add_network(ip1)
    @ipc.add_network(ip2)
    
    #### check network_id after connection
    check_network_id(IpTermination, ip1.id, ip1.aln_termination.id)
    check_network_id(EthernetTermination, eth.id, ip1.network_id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)

  end

end

