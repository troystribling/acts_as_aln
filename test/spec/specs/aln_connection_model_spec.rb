require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should declare descendant association" do 
    AlnConnection.should declare_descendant_association
  end

  it "should include aln_resource ancestor association" do 
    AlnConnection.should be_descendant_of(AlnConnection)
  end

end

#########################################################################################################
describe "adding terminations to a connection", :shared => true do

  it "should be possible for a single termination" do
    @c << @t1
    @c.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @t1.should persist
    @c.should persist
  end

  it "should be possible for multiple terminations of same class" do
    @c << @t1
    @c << @t2
    @c.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @c.aln_terminations.should include(AlnTermination.to_aln_termination(@t2))
  end

  it "should be possible for an array of terminations of same class" do
    @c << [@t1, @t2]
    @c.aln_terminations.should include(AlnTermination.to_aln_termination(@t1))
    @c.aln_terminations.should include(AlnTermination.to_aln_termination(@t2))
  end

  it "should fail for multiple terminations of different classes" do
    lambda{@c << [@t1, @td1]}.should raise_error(PlanB::InvalidClass)
  end
  
end

#########################################################################################################
describe "accessing terminations in a connection", :shared => true do

  it "should be possible by index" do
    @c << [@t1, @t2]
    @c.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
  end

  it "should be possible by iterator" do
    @c << [@t1, @t2]
    @c.aln_terminations.each_index do |i|
      if i.eql?(0)
        @c.aln_terminations[i].should eql(AlnTermination.to_aln_termination(@t1))
      elsif i.eql?(1)
        @c.aln_terminations[i].should eql(AlnTermination.to_aln_termination(@t2))
      else
        @c.aln_terminations.should be_empty
      end
    end
  end

end

#########################################################################################################
describe "removing terminations from a connection", :shared => true do

  it "should be possible for a specified termination without destroying termination" do
    @c << [@t1, @t2]
    @c.aln_terminations.length.should eql(2)
    @c.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
    @c.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
    @t1.should persist
    @t2.should persist
#    @c.aln_terminations.delete(AlnTermination.to_aln_termination(@t1))
#    @c.aln_terminations.length.should eql(1)
#    @c.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t1))
#    @c.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t2))
#    @t1.should persist
#    @t2.should persist
  end

#  it "should be possible for multiple specified terminations without destroying terminations" do
#    @c << [@t1, @t2, @t3]
#    @c.aln_terminations.length.should eql(3)
#    @c.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
#    @c.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
#    @c.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
#    @t1.should persist
#    @t2.should persist
#    @t3.should persist
#    @c.aln_terminations.delete_if do |t|
#      t.direction.eql?('client')
#    end
#    @c.aln_terminations.length.should eql(1)
#    @c.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
#    @c.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t2))
#    @c.aln_terminations.should_not include(AlnTermination.to_aln_termination(@t3))
#    @t1.should persist
#    @t2.should persist
#    @t3.should persist
#  end
#
#  it "should be possible for all terminations without destroying terminations" do
#    @c << [@t1, @t2, @t3]
#    @c.aln_terminations[0].should eql(AlnTermination.to_aln_termination(@t1))
#    @c.aln_terminations[1].should eql(AlnTermination.to_aln_termination(@t2))
#    @c.aln_terminations[2].should eql(AlnTermination.to_aln_termination(@t3))
#    @t1.should persist
#    @t2.should persist
#    @t3.should persist
#    @c.aln_terminations.clear
#    @c.aln_terminations.should be_empty
#    @t1.should persist
#    @t2.should persist
#    @t3.should persist
#  end

end

#########################################################################################################
describe "management of aln_terminations in a connection" do

  before(:each) do
    @t1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @t2 = AlnTermination.new(model_data[:aln_termination_supported_2])
    @t3 = AlnTermination.new(model_data[:aln_termination_supported_3])
    @td1 = IpTermination.new(model_data[:ip_termination_1])
    @c = AlnConnection.new(:termination_type => :aln_termination)
  end
  
  after(:each) do
#    @t1.destroy
#    @t2.destroy
#    @t3.destroy
#    @td1.destroy
#    @c.destroy
  end

#  it_should_behave_like "adding terminations to a connection"
#
#  it_should_behave_like "accessing terminations in a connection"

  it_should_behave_like "removing terminations from a connection"

end

#########################################################################################################
#describe "management of aln_termination descendants in a connection" do
#
#  before(:each) do
#    @t1 = IpTermination.new(model_data[:ip_termination_1])
#    @t2 = IpTermination.new(model_data[:ip_termination_2])
#    @t3 = IpTermination.new(model_data[:ip_termination_3])
#    @td1 = TcpSocketTermination.new(model_data[:tcp_socket_termination_1])
#    @c = AlnConnection.new(:termination_type => :ip_termination)
#  end
#
#  after(:each) do
#    @t1.destroy
#    @t2.destroy
#    @t3.destroy
#    @td1.destroy
#    @c.destroy
#  end
#
#  it_should_behave_like "adding terminations to a connection"
#
#  it_should_behave_like "accessing terminations in a connection"
#
#  it_should_behave_like "removing terminations from a connection"
#
#end
