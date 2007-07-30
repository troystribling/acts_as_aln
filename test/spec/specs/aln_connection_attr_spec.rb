require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# attributes
#########################################################################################################
describe "attributes supported by aln_connection" do
end

#########################################################################################################
# inheritance relations
#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should be able to have descendants" do 
    AlnConnection.new().should respond_to(:get_descendant)
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

