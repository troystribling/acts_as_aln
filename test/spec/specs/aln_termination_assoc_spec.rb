require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# inheritance relations
#########################################################################################################
describe "aln_termination inheritance associations" do

  it "should declare descendant association" do 
    AlnTermination.new().should declare_descendant_association
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

