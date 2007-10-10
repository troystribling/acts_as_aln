require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_termination inheritance associations" do

  it "should declare descendant association" do 
    AlnTermination.new().should declare_descendant_association
  end

  it "should have aln_resource as ancestor association" do 
    AlnTermination.new().should be_descendant_of(AlnResource)
  end

end

#########################################################################################################
describe "aln_termination connection associations" do

  it "should be able to be in a single connection" do 
    AlnTermination.new().should respond_to(:aln_connection_id)
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

  it "should be valid for value peer" do 
    AlnTermination.new(:direction => 'peer').should be_valid
 end

  it "should be inavlid for value different from nil, client, server and peer" do 
    AlnTermination.new(:direction => 'invalid_value').should_not be_valid
 end

end
