require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# attributes
#########################################################################################################
describe "attributes supported by aln_termination" do

  it "should have directionality attribute that can only have vaules nil, unidirectional and bidirectional" do 
    AlnTermination.new().should be_valid
    AlnTermination.new(:directionality => 'unidirectional').should be_valid
    AlnTermination.new(:directionality => 'bidirectional').should be_valid
    AlnTermination.new(:directionality => 'invalid_value').should_not be_valid
  end

  it "should have direction attribute that can only have vaules nil, client, server and peer" do 
    AlnTermination.new().should be_valid
    AlnTermination.new(:direction => 'client').should be_valid
    AlnTermination.new(:direction => 'server').should be_valid
    AlnTermination.new(:direction => 'peer').should be_valid
    AlnTermination.new(:direction => 'invalid_value').should_not be_valid
 end

end

#########################################################################################################
# inheritance relations
#########################################################################################################
describe "aln_termination inheritance associations" do

  it "should be able to have descendants" do 
    AlnTermination.new().should respond_to(:get_descendant)
  end

  it "should have aln_resource as ancestor" do 
    AlnTermination.new().should be_descendant_of(:aln_resource)
  end

end

#########################################################################################################
# connection associations
#########################################################################################################
describe "aln_termination connection associations" do

  it "should be able to be in a connection" do 
    AlnTermination.new().should respond_to(:aln_connection_id)
  end

end

