require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_path inheritance associations" do

  it "should declare descendant association" do 
    AlnPath.should declare_descendant_association
  end

  it "should have aln_resource ancestor association" do 
    AlnPath.should be_descendant_of(AlnResource)
  end

end

##########################################################################################################
describe "attributes supported by aln_connection models" do

  it "should include string identifying connected termination class" do 
    AlnPath.should have_attribute(:termination_type, :string)
  end

end