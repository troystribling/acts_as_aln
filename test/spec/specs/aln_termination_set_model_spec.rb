require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_termination_set inheritance associations" do

  it "should include descendant association" do 
    AlnTerminationSet.should declare_descendant_association
  end

  it "should include aln_resource ancestor association" do 
    AlnTerminationSet.should be_descendant_of(AlnResource)
  end

end

#########################################################################################################
describe "aln_termination_set termination associations" do

  it "should include many terminations" do 
    AlnTerminationSet.new.should have_method(:aln_terminations)
  end

end

#########################################################################################################
describe "aln_termination_set attributes" do

  it "should include termination_type" do 
    AlnTerminationSet.should have_attribute(:termination_type, :integer)
  end

  it "should require termination_type specification on constructor" do 
    lambda{AlnTerminationSet.new()}.should raise_error(ArgumentError) 
    lambda{AlnTerminationSet.new(:termination_type => :tcp_socket_termination)}.should_not raise_error(ArgumentError) 
  end

end

##########################################################################################################
describe "retrieval of aln_termination_set ancestor from aln_termination_set descendant model class" do

  it "should return aln_termination_set if model is aln_termination_set" do
    AlnTerminationSet.to_aln_termination_set(AlnTerminationSet.new).class.should eql(AlnTerminationSet) 
  end

  it "should return aln_termination_set if model is a descendant of aln_termination_set" do 
    AlnTerminationSet.to_aln_termination_set(AlnConnection.new).class.should eql(AlnTerminationSet) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{AlnTerminationSet.to_aln_termination_set(Array.new)}.should raise_error(NoMethodError) 
  end
  
end



