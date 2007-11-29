require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_termination inheritance associations" do

  it "should declare descendant association" do 
    AlnTermination.should declare_descendant_association
  end

  it "should include aln_resource as ancestor association" do 
    AlnTermination.should be_descendant_of(AlnResource)
  end

end

#########################################################################################################
describe "aln_termination associations" do

  it "should include aln_connection" do 
    AlnTermination.should have_attribute(:aln_connection_id, :integer)
  end

  it "should include aln_path" do 
    AlnTermination.should have_attribute(:aln_path_id, :integer)
  end

end

##########################################################################################################
describe "attributes supported by aln_termination models" do

  it "should include network identifier" do 
    AlnTermination.should have_attribute(:network_id, :integer)
  end

  it "should include layer identifier" do 
    AlnTermination.should have_attribute(:layer_id, :integer)
  end

  it "should include path identifier" do 
    AlnTermination.should have_attribute(:aln_path_id, :integer)
  end

end

#########################################################################################################
describe "aln_termination directionality attribute" do

  it "should be valid for value nil" do 
    AlnTermination.new().should be_valid
  end

  it "should be valid for value unidirectional" do 
    AlnTermination.new(:directionality => 'unidirectional').should be_valid
  end

  it "should be valid for value bidirectional" do 
    AlnTermination.new(:directionality => 'bidirectional').should be_valid
  end

  it "should be inavlid for value different from nil, unidirectional or bidirectional" do 
    AlnTermination.new(:directionality => 'invalid_value').should_not be_valid
  end

end

#########################################################################################################
describe "aln_termination direction attribute" do

  it "should be valid for value nil" do 
    AlnTermination.new().should be_valid
 end

  it "should be valid for value client" do 
    AlnTermination.new(:direction => 'client').should be_valid
 end

  it "should be valid for value server" do 
    AlnTermination.new(:direction => 'server').should be_valid
 end

  it "should be inavlid for value different from nil, client, server and peer" do 
    AlnTermination.new(:direction => 'invalid_value').should_not be_valid
 end

end

##########################################################################################################
describe "retrieval of aln_termination ancestor from aln_termination descendant model class" do

  it "should return aln_termination if model is aln_termination" do
    AlnTermination.to_aln_termination(AlnTermination.new(model_data[:aln_termination])).class.should eql(AlnTermination) 
  end

  it "should return aln_resource if model is a descendant of aln_resource" do 
    AlnTermination.to_aln_termination(EthernetTermination.new(model_data[:aln_termination])).class.should eql(AlnTermination) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{AlnTermination.to_aln_termination(Array.new)}.should raise_error(NoMethodError) 
  end
  
end
