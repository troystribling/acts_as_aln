require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should declare descendant association" do 
    AlnConnection.should declare_descendant_association
  end

  it "should have aln_resource ancestor association" do 
    AlnConnection.should be_descendant_of(AlnTerminationSet)
  end

end



