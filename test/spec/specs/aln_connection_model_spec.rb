require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should declare descendant association" do 
    AlnConnection.should declare_descendant_association
  end

  it "should include aln_resource ancestor association" do 
    AlnConnection.should be_descendant_of(AlnTerminationSet)
  end

end

#########################################################################################################
describe "adding terminations to a connection", :shared => true do

  it "should be possible for a single termination" do
  end

  it "should be possible for a multiple terminations of same class" do
  end

  it "should fail for multiple terminations of different classes" do
  end
  
end

#########################################################################################################
describe "accessing terminations in a connection", :shared => true do

  it "should be possible by index" do
  end

  it "should be possible by iterator" do
  end

end

#########################################################################################################
describe "removing terminations from a connection", :shared => true do

  it "should be possible for a specified termination" do
  end

  it "should be possible for multiple specified terminations" do
  end

  it "should be possible for all terminations" do
  end

end

#########################################################################################################
describe "management of aln_terminations in a connection" do

  before(:each) do
    @t1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @t2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @td1 = IpTermination.new(model_data[:ip_termination_1])
    @c = AlnConnection.new(:termination_type => :aln_termination)
  end

  it_should_behave_like "adding terminations to a connection"

  it_should_behave_like "acessing terminations in a connection"

  it_should_behave_like "removing terminations from a connection"

end

#########################################################################################################
describe "management of aln_termination descendants in a connection" do

  before(:each) do
    @t1 = IpTermination.new(model_data[:ip_termination_1])
    @t2 = IpTermination.new(model_data[:ip_termination_2])
    @td1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
    @c = AlnConnection.new(:termination_type => :ip_termination)
  end

  it_should_behave_like "adding terminations to a connection"

  it_should_behave_like "acessing terminations in a connection"

  it_should_behave_like "removing terminations from a connection"

end
