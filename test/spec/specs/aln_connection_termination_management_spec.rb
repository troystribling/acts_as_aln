require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "adding terminations to a connection", :shared => true do

  it "should be possible for a single termination" do
    @c1 << @t1
    @c1.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @t1.should persist
    @c1.should persist
  end

  it "should be possible for multiple terminations of same class" do
    @c1 << @t1
    @c1 << @t2
    @c1.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations.should include(AlnTermination.to_aln_termination(@t2))
  end

  it "should be possible for an array of terminations of same class" do
    @c1 << [@t1, @t2]
    @c1.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations.should include(AlnTermination.to_aln_termination(@t2))
  end

  it "should fail when termination does not match :termination_type" do
    lambda{@c1 << [@t1, @td1]}.should raise_error(PlanB::InvalidClass)
  end

  it "should fail when terminations do not have the same support hierarchy root" do
    @nic1 << @t1
    @nic2 << @t2
    lambda{@c1 << [@t1, @t2]}.should raise_error(PlanB::TerminationInvalid)
  end

  it "should fail when termination is in another connection" do
    @c2 << @t2
    lambda{@c1 << [@t1, @t2]}.should raise_error(PlanB::TerminationInvalid)
  end
  
end

#########################################################################################################
describe "accessing terminations in a connection", :shared => true do

  it "should be possible by index" do
    @c1 << [@t1, @t2]
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
  end

  it "should be possible by iterator" do
    @c1 << [@t1, @t2]
    @c1.aln_terminations.each_index do |i|
      if i.eql?(0)
        @c1.aln_terminations[i].should eql(AlnTermination.to_aln_termination(@t1))
      elsif i.eql?(1)
        @c1.aln_terminations[i].should eql(AlnTermination.to_aln_termination(@t2))
      else
        @c1.aln_terminations.should be_empty
      end
    end
  end

end

#########################################################################################################
describe "removing terminations from a connection", :shared => true do

  def verify_connection_termination_persistence
    AlnTermination.to_aln_termination(@t1).should persist
    AlnTermination.to_aln_termination(@t2).should persist
    AlnTermination.to_aln_termination(@t3).should persist
    @t1.should persist
    @t2.should persist
    @t3.should persist
  end

  def verify_connection_removal(term)
    term.reload
    term.aln_connection_id.should be_nil
    term.aln_connection.should be_nil
  end
  
  it "should be possible for a specified termination without destroying termination" do
    @c1 << [@t1, @t2, @t3]
    @c1.aln_terminations.length.should eql(3)
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @c1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_connection_termination_persistence
    @c1.remove_termination(@t1)
    @c1.aln_terminations.length.should eql(2)
    @c1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t2))
    @c1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t3))
    verify_connection_termination_persistence
    verify_connection_removal(@t1)
  end

  it "should be possible for multiple specified terminations without destroying terminations" do
    @c1 << [@t1, @t2, @t3]
    @c1.aln_terminations.length.should eql(3)
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @c1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_connection_termination_persistence
    @c1.remove_termination([@t1, @t2])
    @c1.aln_terminations.length.should eql(1)
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t3))
    @c1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t2))
    verify_connection_termination_persistence
    verify_connection_removal(@t1)
    verify_connection_removal(@t2)
  end

  it "should be possible for multiple terminations matching a specified condition without destroying terminations" do
    @c1 << [@t1, @t2, @t3]
    @c1.aln_terminations.length.should eql(3)
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @c1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_connection_termination_persistence
    @c1.remove_termination_if do |t|
      t.direction.eql?('client')
    end
    @c1.aln_terminations.length.should eql(1)
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t2))
    @c1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t3))
    verify_connection_termination_persistence
    verify_connection_removal(@t2)
    verify_connection_removal(@t3)
  end

  it "should be possible for all terminations without destroying terminations" do
    @c1 << [@t1, @t2, @t3]
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @c1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_connection_termination_persistence
    @c1.remove_all_terminations
    @c1.aln_terminations.should be_empty
    verify_connection_termination_persistence
    verify_connection_removal(@t1)
    verify_connection_removal(@t2)
    verify_connection_removal(@t3)
  end

end

#########################################################################################################
describe "retrieval of connection from contained termination", :shared => true do

  it "should be possible" do
    @c1 << @t1
    @t1.aln_connection.should eql(@c1)
  end
  
end

#########################################################################################################
describe "retrieval of contained termination from connection", :shared => true do

  it "should be possible for first termination as AlnTermination class" do
    @c1 << [@t1, @t2, @t3]
    @c1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c1.aln_terminations[0].should be_class(AlnTermination)
  end

  it "should be possible for a specifed termination as AlnTermination class" do
    @c1 << [@t1, @t2, @t3]
    mods = @c1.aln_terminations.select do |t|
      t.direction.eql?('client')      
    end
    mods.should have_attributes_with_values([AlnTermination.to_aln_termination(@t2).attributes, AlnTermination.to_aln_termination(@t3).attributes])
    mods.should be_class(AlnTermination)
  end

  it "should be possible for all terminations as AlnTermination class" do
    @c1 << [@t1, @t2, @t3]
    @c1.aln_terminations.should have_attributes_with_values([AlnTermination.to_aln_termination(@t1).attributes, AlnTermination.to_aln_termination(@t2).attributes, AlnTermination.to_aln_termination(@t3).attributes])
    @c1.aln_terminations.should be_class(AlnTermination)
  end

  it "should be possible for first termination as :termination_type class" do
    @c1 << [@t1, @t2, @t3]
    mod = @c1.find_termination_as_type(:first) 
    mod.should match_attributes_with(@match_attributes, @t1)
    mod.should be_class(@t1.class)
  end

  it "should be possible for a specifed termination as :termination_type class" do
    @c1 << [@t1, @t2, @t3]
    mods = @c1.find_termination_as_type(:all, :conditions => "aln_terminations.direction = 'client'") 
    mods.should match_attributes_with(@match_attributes, [@t2, @t3])
    mods.should be_class(@t1.class)
  end

  it "should be possible for all terminations as :termination_type class" do
    @c1 << [@t1, @t2, @t3]
    mods = @c1.find_termination_as_type(:all) 
    mods.should match_attributes_with(@match_attributes, [@t1, @t2, @t3])
    mods.should be_class(@t1.class)
  end
  
end

#########################################################################################################
describe "management of aln_terminations in a connection" do

  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @c1 = AlnConnection.new(:termination_type => :aln_termination)
    @c2 = AlnConnection.new(:termination_type => :aln_termination)
    @t1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @t2 = AlnTermination.new(model_data[:aln_termination_supported_2])
    @t3 = AlnTermination.new(model_data[:aln_termination_supported_3])
    @td1 = IpTermination.new(model_data[:ip_termination_1])
    @match_attributes = [:aln_connection_id, :directionality, :resource_name, :direction, :layer_id]
  end
  
  after(:each) do
    @c1.destroy
    @c2.destroy
    @nic1.destroy
    @nic2.destroy
    @t1.destroy
    @t2.destroy
    @t3.destroy
    @td1.destroy
  end

  it_should_behave_like "adding terminations to a connection"

  it_should_behave_like "accessing terminations in a connection"

  it_should_behave_like "removing terminations from a connection"

  it_should_behave_like "retrieval of connection from contained termination"

  it_should_behave_like "retrieval of contained termination from connection"

end

#########################################################################################################
describe "management of aln_termination descendants in a connection" do

  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @c1 = AlnConnection.new(:termination_type => :ip_termination)
    @c2 = AlnConnection.new(:termination_type => :ip_termination)
    @t1 = IpTermination.new(model_data[:ip_termination_query_1])
    @t2 = IpTermination.new(model_data[:ip_termination_query_2])
    @t3 = IpTermination.new(model_data[:ip_termination_query_3])
    @td1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    @match_attributes = [:aln_connection_id, :network_id, :directionality, :resource_name, :direction, :layer_id, :ip_addr]
  end

  after(:each) do
    @c1.destroy
    @c2.destroy
    @nic1.destroy
    @nic2.destroy
    @t1.destroy
    @t2.destroy
    @t3.destroy
    @td1.destroy
  end

  it_should_behave_like "adding terminations to a connection"

  it_should_behave_like "accessing terminations in a connection"

  it_should_behave_like "removing terminations from a connection"

  it_should_behave_like "retrieval of connection from contained termination"

  it_should_behave_like "retrieval of contained termination from connection"

end
