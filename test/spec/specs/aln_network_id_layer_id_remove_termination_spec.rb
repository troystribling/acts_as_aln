require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "assignement of network ID for terminations after deatching from supporting relationship where the terminations are not involved in a connection but may have supported" do

  before(:each) do
    @server = Server.new(model_data[:server_1])
    @nic = Nic.new(model_data[:nic_1]) 
    @server << @nic 
  end

  after(:each) do
    @server.destroy
  end
  
  it "should be aln_termination_id of supported if supported and supporter have no supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])

    #### create support relationships
    @nic << eth    
    eth << ip

    #### validate initial configuration 
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip.id, eth.aln_termination.id)

    #### detach from support hierarchy
    ip.detach_support_hierarchy

    #### validate final configuration
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip.id, ip.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip.id, nil)
    
    #### clean up
    ip.destroy
    
  end

  it "should be aln_termination_id of supported if supporter has no supported but supported has supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip = IpTermination.new(model_data[:ip_termination_1])
    tcp = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])

    #### create support relationships
    @nic << eth 
    eth << ip   
    ip << tcp

    #### validate initial configuration 
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip.id, eth.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip.aln_termination.id)

    #### detach from support hierarchy
    ip.detach_support_hierarchy

    #### validate final configuration
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip.id, ip.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip.id, nil)
    check_network_id(TcpSocketTermination, tcp.id, ip.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip.aln_termination.id)

    #### clean up
    ip.destroy

  end

  it "should be aln_termination_id of supported if supported has no supported but supporter has supported" do 

    #### create models
    eth = EthernetTermination.new(model_data[:ethernet_termination_1])
    ip1 = IpTermination.new(model_data[:ip_termination_1])
    ip2 = IpTermination.new(model_data[:ip_termination_2])

    #### create support relationships
    @nic << eth    
    eth << [ip1, ip2]

    #### validate initial configuration 
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip2.id, eth.aln_termination.id)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final configuration
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)

    #### clean up
    ip2.destroy

  end

  it "should be aln_termination_id of supported if supported and supporter have supported" do 

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
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip2.id, eth.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip2.aln_termination.id)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final configuration
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_network_id(TcpSocketTermination, tcp.id, ip2.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp.id, ip2.aln_termination.id)

    #### clean up
    ip2.destroy

  end

  it "should be aln_termination_id of supported if supported and supporter have multiple supported" do 

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

    #### validate initial configuration 
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_network_id(IpTermination, ip2.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip2.id, eth.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip1.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip1.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp3.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, ip2.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp4.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, ip2.aln_termination.id)

    #### detach from support hierarchy
    ip2.detach_support_hierarchy

    #### validate final configuration
    check_network_id(EthernetTermination, eth.id, eth.aln_termination.id)
    check_termination_supporter_id(EthernetTermination, eth.id, nil)
    check_network_id(IpTermination, ip1.id, eth.network_id)
    check_termination_supporter_id(IpTermination, ip1.id, eth.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp1.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp1.id, ip1.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp2.id, eth.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp2.id, ip1.aln_termination.id)

    check_network_id(IpTermination, ip2.id, ip2.aln_termination.id)
    check_termination_supporter_id(IpTermination, ip2.id, nil)
    check_network_id(TcpSocketTermination, tcp3.id, ip2.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp3.id, ip2.aln_termination.id)
    check_network_id(TcpSocketTermination, tcp4.id, ip2.network_id)
    check_termination_supporter_id(TcpSocketTermination, tcp4.id, ip2.aln_termination.id)

    #### clean up
    ip2.destroy

  end


end

##########################################################################################################
describe "assignement of network ID for terminations after deatching from supporting relationship where the terminations are nvolved in connections but and have supported" do
end