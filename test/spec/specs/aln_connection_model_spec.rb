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
describe "adding terminations to a connection" do
end

#########################################################################################################
describe "removing terminations from a connection" do
end

#########################################################################################################
describe "managment of aln_terminations in a connection" do
end

#########################################################################################################
describe "managment of aln_termination descendants in a connection" do
end
