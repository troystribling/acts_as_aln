require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "adding terminations to a path", :shared => true do

  it "should be possible for a single termination" do
    @p1 << @t1
    @p1.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @t1.should persist
    @p1.should persist
  end

  it "should be possible for multiple terminations of same class" do
    @p1 << @t1
    @p1 << @t2
    @p1.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations.should include(AlnTermination.to_aln_termination(@t2))
  end

  it "should be possible for an array of terminations of same class" do
    @p1 << [@t1, @t2]
    @p1.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations.should include(AlnTermination.to_aln_termination(@t2))
  end

  it "should fail when termination does not match :termination_type" do
    lambda{@p1 << [@t1, @td1]}.should raise_error(PlanB::InvalidClass)
  end

  it "should fail when terminations do not have the same support hierarchy root" do
    @nic1 << @t1
    @nic2 << @t2
    lambda{@p1 << [@t1, @t2]}.should raise_error(PlanB::TerminationInvalid)
  end

  it "should fail when termination is in another path" do
    @p2 << @t2
    lambda{@p1 << [@t1, @t2]}.should raise_error(PlanB::TerminationInvalid)
  end

  it "should fail when termination is in another network" do
    @nic1 << @td1 
    @td1 << @t1
    @nic2 << @td2 
    @td2 << @t2
    lambda{@p1 << [@t1, @t2]}.should raise_error(PlanB::TerminationInvalid)
  end
  
end

#########################################################################################################
describe "accessing terminations in a path", :shared => true do

  it "should be possible by index" do
    @p1 << [@t1, @t2]
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
  end

  it "should be possible by iterator" do
    @p1 << [@t1, @t2]
    @p1.aln_terminations.each_index do |i|
      if i.eql?(0)
        @p1.aln_terminations[i].should eql(AlnTermination.to_aln_termination(@t1))
      elsif i.eql?(1)
        @p1.aln_terminations[i].should eql(AlnTermination.to_aln_termination(@t2))
      else
        @p1.aln_terminations.should be_empty
      end
    end
  end

end

#########################################################################################################
describe "adding terminations to a persistent path", :shared => true do

  it "should be possible to add multiple terminations when path is retrieved prior to adding each termination" do
    @c1.save
    c1_chk = AlnConnection.find(@c1.aln_connection_id)
    c1_chk << @t1
    @t1.save
    t1_chk = AlnTermination.find(@t1.aln_termination_id)
    c2_chk = AlnConnection.find(@c1.aln_connection_id)
    c2_chk << @t2
    @t2.save
    t2_chk = AlnTermination.find(@t2.aln_termination_id)
    AlnConnection.find(@c1.aln_connection_id).aln_terminations.should include(AlnTermination.to_aln_termination(t1_chk))
    AlnConnection.find(@c1.aln_connection_id).aln_terminations.should include(AlnTermination.to_aln_termination(t2_chk))
  end
  
end

#########################################################################################################
describe "removing terminations from a path", :shared => true do

  def verify_path_termination_persistence
    AlnTermination.to_aln_termination(@t1).should persist
    AlnTermination.to_aln_termination(@t2).should persist
    AlnTermination.to_aln_termination(@t3).should persist
    @t1.should persist
    @t2.should persist
    @t3.should persist
  end

  def verify_path_removal(term)
    term.reload
    term.aln_path_id.should be_nil
    term.aln_path.should be_nil
  end
  
  it "should be possible for a specified termination without destroying termination" do
    @p1 << [@t1, @t2, @t3]
    @p1.aln_terminations.length.should eql(3)
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @p1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_path_termination_persistence
    @p1.remove_termination(@t1)
    @p1.aln_terminations.length.should eql(2)
    @p1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t2))
    @p1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t3))
    verify_path_termination_persistence
    verify_path_removal(@t1)
  end

  it "should be possible for multiple specified terminations without destroying terminations" do
    @p1 << [@t1, @t2, @t3]
    @p1.aln_terminations.length.should eql(3)
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @p1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_path_termination_persistence
    @p1.remove_termination([@t1, @t2])
    @p1.aln_terminations.length.should eql(1)
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t3))
    @p1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t2))
    verify_path_termination_persistence
    verify_path_removal(@t1)
    verify_path_removal(@t2)
  end

  it "should be possible for multiple terminations matching a specified condition without destroying terminations" do
    @p1 << [@t1, @t2, @t3]
    @p1.aln_terminations.length.should eql(3)
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @p1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_path_termination_persistence
    @p1.remove_termination_if do |t|
      t.direction.eql?('client')
    end
    @p1.aln_terminations.length.should eql(1)
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t2))
    @p1.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t3))
    verify_path_termination_persistence
    verify_path_removal(@t2)
    verify_path_removal(@t3)
  end

  it "should be possible for all terminations without destroying terminations" do
    @p1 << [@t1, @t2, @t3]
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @p1.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
    verify_path_termination_persistence
    @p1.remove_all_terminations
    @p1.aln_terminations.should be_empty
    verify_path_termination_persistence
    verify_path_removal(@t1)
    verify_path_removal(@t2)
    verify_path_removal(@t3)
  end

end

#########################################################################################################
describe "retrieval of path from contained termination", :shared => true do

  it "should be possible" do
    @p1 << @t1
    @t1.aln_path.should eql(@p1)
  end
  
end

#########################################################################################################
describe "retrieval of contained termination from path", :shared => true do

  it "should be possible for first termination as AlnTermination class" do
    @p1 << [@t1, @t2, @t3]
    @p1.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @p1.aln_terminations[0].should be_class(AlnTermination)
  end

  it "should be possible for a specifed termination as AlnTermination class" do
    @p1 << [@t1, @t2, @t3]
    mods = @p1.aln_terminations.select do |t|
      t.direction.eql?('client')      
    end
    mods.should have_attributes_with_values([AlnTermination.to_aln_termination(@t2).attributes, AlnTermination.to_aln_termination(@t3).attributes])
    mods.should be_class(AlnTermination)
  end

  it "should be possible for all terminations as AlnTermination class" do
    @p1 << [@t1, @t2, @t3]
    @p1.aln_terminations.to_a.should have_attributes_with_values([AlnTermination.to_aln_termination(@t1).attributes, AlnTermination.to_aln_termination(@t2).attributes, AlnTermination.to_aln_termination(@t3).attributes])
    @p1.aln_terminations.to_a.should be_class(AlnTermination)
  end

  it "should be possible for first termination as :termination_type class" do
    @p1 << [@t1, @t2, @t3]
    mod = @p1.find_termination_as_type(:first) 
    mod.should match_attributes_with(@match_attributes, @t1)
    mod.should be_class(@t1.class)
  end

  it "should be possible for a specifed termination as :termination_type class" do
    @p1 << [@t1, @t2, @t3]
    mods = @p1.find_termination_as_type(:all, :conditions => "aln_terminations.direction = 'client'") 
    mods.should match_attributes_with(@match_attributes, [@t2, @t3])
    mods.should be_class(@t1.class)
  end

  it "should be possible for all terminations as :termination_type class" do
    @p1 << [@t1, @t2, @t3]
    mods = @p1.find_termination_as_type(:all) 
    mods.should match_attributes_with(@match_attributes, [@t1, @t2, @t3])
    mods.should be_class(@t1.class)
  end
  
end

#########################################################################################################
describe "management of aln_terminations in a path" do

  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @p1 = AlnPath.new(:termination_type => 'AlnTermination')
    @p2 = AlnPath.new(:termination_type => 'AlnTermination')
    @t1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @t2 = AlnTermination.new(model_data[:aln_termination_supported_2])
    @t3 = AlnTermination.new(model_data[:aln_termination_supported_3])
    @td1 = IpTermination.new(model_data[:ip_termination_1])
    @td2 = IpTermination.new(model_data[:ip_termination_2])
    @match_attributes = [:aln_path_id, :directionality, :name, :direction, :layer_id]
  end
  
  after(:each) do
    @p1.destroy
    @p2.destroy
    @nic1.destroy
    @nic2.destroy
    @t1.destroy
    @t2.destroy
    @t3.destroy
    @td1.destroy
  end

  it_should_behave_like "adding terminations to a path"

  it_should_behave_like "accessing terminations in a path"

  it_should_behave_like "removing terminations from a path"

  it_should_behave_like "retrieval of path from contained termination"

  it_should_behave_like "retrieval of contained termination from path"

end

#########################################################################################################
describe "management of aln_termination descendants in a path" do

  before(:each) do
    @nic1 = Nic.new(model_data[:nic_1]) 
    @nic2 = Nic.new(model_data[:nic_2]) 
    @p1 = AlnPath.new(:termination_type => 'IpTermination')
    @p2 = AlnPath.new(:termination_type => 'IpTermination')
    @t1 = IpTermination.new(model_data[:ip_termination_query_1])
    @t2 = IpTermination.new(model_data[:ip_termination_query_2])
    @t3 = IpTermination.new(model_data[:ip_termination_query_3])
    @td1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    @td2 = TcpSocketTermination.new(model_data[:tcp_socket_termination_2])
    @match_attributes = [:aln_path_id, :network_id, :directionality, :name, :direction, :layer_id, :ip_addr]
  end

  after(:each) do
    @p1.destroy
    @p2.destroy
    @nic1.destroy
    @nic2.destroy
    @t1.destroy
    @t2.destroy
    @t3.destroy
    @td1.destroy
  end

  it_should_behave_like "adding terminations to a path"

  it_should_behave_like "accessing terminations in a path"

  it_should_behave_like "removing terminations from a path"

  it_should_behave_like "retrieval of path from contained termination"

  it_should_behave_like "retrieval of contained termination from path"

end

#########################################################################################################
describe "management of aln_termination descendants in a persistent connection" do

  before(:each) do
    @p1 = AlnPath.new(:termination_type => 'IpTermination')
    @p2 = AlnPath.new(:termination_type => 'IpTermination')
    @t1 = IpTermination.new(model_data[:ip_termination_query_1])
    @t2 = IpTermination.new(model_data[:ip_termination_query_2])
    @t3 = IpTermination.new(model_data[:ip_termination_query_3])
    @td1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
  end

  after(:each) do
    @p1.destroy
    @p2.destroy
    @t1.destroy
    @t2.destroy
    @t3.destroy
    @td1.destroy
  end

  it_should_behave_like "adding terminations to a persistent path"

end
