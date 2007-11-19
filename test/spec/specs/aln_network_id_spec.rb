require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
module NetworkIdHelper

  def check_network_id(model, id, network_id)
    chk = model.find(id)
    chk.network_id.should eql(network_id)
  end
  
end

#########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established where the terminations are not involved in a connection or other support relations with terminations" do

  include NetworkIdHelper
  
  before(:each) do
    @nic = Nic.new(model_data[:nic_1]) 
  end

  after(:each) do
    @nic.destroy
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

#########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established where the terminations are not involved in a connection but either or both may be in other prior support relations with terminations" do

  include NetworkIdHelper
  
  before(:each) do
    @nic = Nic.new(model_data[:nic_1]) 
  end

  after(:each) do
    @nic.destroy
  end
  
  it "should be aln_termination_id of supporter when supporter is not in a prior support relationship with an aln_termination descendant and supported is not in a prior support relationship with an aln_termination descendant" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support root relationship
    @nic << eth    
    eth << ip

    #### check network_ids
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth.network_id)

  end

  it "should be aln_termination_id of supporter when supporter is not in a prior supporting relationship with an aln_termination descendant and supported is in a prior support relationship with an aln_termination descendant" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support root relationship
    @nic << eth    

    #### create supported relationship
    ip << tcp

    #### check supported network_ids
    check_network_id(IpTermination, ip.id, ip.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp.id, ip.network_id)

    #### add supported network to support root
    eth.add_network(ip)

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
 
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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)

    #### check supported network_id
    check_network_id(IpTermination, ip1.id, eth.network_id)

    #### create second support relationship
    eth << ip2

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)

    #### check supported network_id
    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp.id, ip2.network_id)

    #### add supported network to support root
    eth.add_network(ip2)

    #### check support root network_id
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_network_id(TcpSocketTermination, tcp.id, eth.network_id)
    
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when added to a connection where the terminations are not involved in other prior connections or other prior support relations" do

  include NetworkIdHelper
  
  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @c = AlnConnection.new(:resource_name => 'ethernet_connection', :connected_termination_type => :ethernet_termination)
  end

  after(:each) do
    @nic1.destroy
    @nic2.destroy
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
    @c << eth1
    @c << eth2
    
    #### check network_id
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)

  end

end

#########################################################################################################
describe "assignement of network ID for terminations when termination hierarchy root is added to a connection if either or both terminations are involved in prior support relations with other terminations" do

  include NetworkIdHelper
  
  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @c = AlnConnection.new(:resource_name => 'ethernet_connection', :connected_termination_type => :ethernet_termination)
  end

  after(:each) do
    @nic1.destroy
    @nic2.destroy
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
    check_network_id(EthernetTermination, eth2.id, eth2.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth1.network_id)
    
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
    check_network_id(EthernetTermination, eth2.id, eth2.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
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
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
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

#########################################################################################################
describe "assignement of network ID for terminations when termination supported is added to a connection" do

  include NetworkIdHelper
  
  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @ethc = AlnConnection.new(:resource_name => 'ethernet_connection', :connected_termination_type => :ethernet_termination)
    @ipc = AlnConnection.new(:resource_name => 'ip_connection', :connected_termination_type => :ip_termination)
  end

  after(:each) do
    @nic1.destroy
    @nic2.destroy
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
    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    
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
    check_network_id(IpTermination, ip1.id, ip1.aln_termination.id)
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

#########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established if either or both terminations are in a connection but neither are in other prior support relations with terminations" do

  include NetworkIdHelper
  
  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @ethc = AlnConnection.new(:resource_name => 'ethernet_connection', :connected_termination_type => :ethernet_termination)
    @ipc = AlnConnection.new(:resource_name => 'ip_connection', :connected_termination_type => :ip_termination)
  end

  after(:each) do
    @nic1.destroy
    @nic2.destroy
    @nic3.destroy
    @ethc.destroy
    @ipc.destroy
  end
  
  it "should be aln_termination_id of supporter when supporter is not in a prior connection and supported is in a prior connection" do 

    #### create terminations
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create non terminating support relationships
    @nic1 << eth
    @nic2 << ip2
        
    #### create connections
    @ipc << ip1
    @ipc << ip2
    
    #### check network_id prior creating support realtionship
    check_network_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip1.id, ip1.aln_termination.id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)
    
    #### create support relationship
    eth << ip2

    #### check network_id after creating support realtionship
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    
  end

  it "should be network ID of supporter when supporter is in a prior connection and supported is in a prior connection" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create non terminating support relationships
    @nic1 << eth1
    @nic2 << eth2
    @nic3 << ip2
        
    #### create connections
    @ethc << eth1
    @ethc << eth2
    @ipc << ip1
    @ipc << ip2
    
    #### check network_id prior creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, ip1.aln_termination.id)
    check_network_id(IpTermination, ip2.id, ip1.network_id)
    
    #### create support relationship
    eth2 << ip2

    #### check network_id after creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, eth1.network_id)
    check_network_id(IpTermination, ip2.id, eth1.network_id)
        
  end
  
  it "should be network ID of supporter when supporter is in a prior connection and supported is not in a prior connection" do 

    #### create terminations
    eth1 = EthernetTermination.new(model_data[:ethernet_termination_1])
    eth2 = EthernetTermination.new(model_data[:ethernet_termination_2])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create non terminating support relationships
    @nic1 << eth1
    @nic2 << eth2
        
    #### create connections
    @ethc << eth1
    @ethc << eth2
    
    #### check network_id prior creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip1.id, nil)
    
    #### create support relationship
    eth2 << ip

    #### check network_id after creating support realtionship
    check_network_id(EthernetTermination, eth1.id, eth1.aln_termination.id)
    check_network_id(EthernetTermination, eth2.id, eth1.network_id)
    check_network_id(IpTermination, ip.id, eth1.network_id)
    
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when a support relationship is established if either or both terminations are in a connection and either are in other prior support relations with terminations" do

  include NetworkIdHelper
  
  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @nic3 = Nic.new(model_data[:nic_3]) 
    @ethc = AlnConnection.new(:resource_name => 'ethernet_connection', :connected_termination_type => :ethernet_termination)
    @ipc = AlnConnection.new(:resource_name => 'ip_connection', :connected_termination_type => :ip_termination)
  end

  after(:each) do
    @nic1.destroy
    @nic2.destroy
    @nic3.destroy
    @ethc.destroy
    @ipc.destroy
  end
  
  it "should be aln_termination_id of supporter when supporter is not in a prior connection or support relationship and supported is in a prior connection and support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and not in a support relationship and supported is in a prior connection and support relationship" do 
  end

  it "should be network ID of supporter when supporter is not in a prior connection and is in a support relationship and supported is in a prior connection and support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is not in a prior connection or support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is not in a prior connection but is in a prior support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is in a prior connection but is not in a prior support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is in a prior connection and support relationship" do 
  end

end
