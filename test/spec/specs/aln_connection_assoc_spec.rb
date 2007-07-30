require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# inheritance relations
#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should declare descendant association" do 
    AlnConnection.new().should declare_descendant_association
  end

  it "should have aln_resource as ancestor" do 
    AlnConnection.new().should be_descendant_of(:aln_resource)
  end

end

#########################################################################################################
# termination associations
#########################################################################################################
describe "aln_connection termination associations" do

  it "should be able to have many terminations" do 
    AlnConnection.new().should respond_to(:aln_terminations)
  end

end

