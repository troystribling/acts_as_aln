require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_termination inheritance associations" do

  it "should declare descendant association" do 
    AlnTermination.new().should declare_descendant_association
  end

  it "should have aln_resource as ancestor association" do 
    AlnTermination.new().should be_descendant_of(:aln_resource)
  end

end

#########################################################################################################
describe "aln_termination connection associations" do

  it "should be able to be in a single connection" do 
    AlnTermination.new().should respond_to(:aln_connection_id)
  end

end

