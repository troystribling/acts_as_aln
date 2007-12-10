require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "assignement of layer ID for terminations after deatching from supporting relationship where the terminations are not involved in a connection but may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic 
  end

  after(:each) do
    @server.destroy
  end
  
  it "should have 0 for maximum layer ID if supported and supporter has no supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relationships
    @nic << eth    
    eth << ip

    #### validate initial configuration 
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip.id, 1)

    #### detach from support hierarchy
    ip.detach_support_hierarchy

    #### validate final configuration
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip.id, 0)

    #### clean up
    ip.destroy
    
  end

  it "should have 1 for maximum layer ID if supporter has no supported but supported has supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support relationships
    @nic << eth 
    eth << ip   
    ip << tcp

    #### validate initial configuration 
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 2)

    #### detach from support hierarchy
    ip.detach_support_hierarchy

    #### validate final configuration
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip.id, 0)
    check_layer_id(TcpSocketTermination, tcp.id, 1)

    #### clean up
    ip.destroy
    
  end

  it "should have 0 for maximum layer ID if supported has no supported but supporter has supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support relationships
    @nic << eth    
    eth << [ip1, ip2]

    #### validate initial configuration 
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final configuration
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 0)

    #### clean up
    ip2.destroy

  end

  it "should have 1 for maximum layer ID if supported and supporter have supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support relationships
    @nic << eth
    eth << [ip1, ip2]
    ip2 << tcp

    #### validate initial configuration 
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 1)
    check_layer_id(TcpSocketTermination, tcp.id, 2)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final configuration
    check_layer_id(EthernetTermination, eth.id, 0)
    check_layer_id(IpTermination, ip1.id, 1)
    check_layer_id(IpTermination, ip2.id, 0)
    check_layer_id(TcpSocketTermination, tcp.id, 1)

    #### clean up
    ip2.destroy

  end

end

