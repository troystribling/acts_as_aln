require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should declare descendant association" do 
    AlnConnection.should declare_descendant_association
  end

  it "should include aln_resource ancestor association" do 
    AlnConnection.should be_descendant_of(AlnResource)
  end

end

##########################################################################################################
describe "attributes supported by aln_connection models" do

  it "should include string identifying connected termination class" do 
    AlnConnection.should have_attribute(:termination_type, :string)
  end

end