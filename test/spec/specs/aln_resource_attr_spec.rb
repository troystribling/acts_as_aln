require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "attributes supported by aln_resource models" do

  it "should include date and time of model creation" do 
    AlnResource.should have_attribute(:created_at, :datetime)
  end

  it "should include date and time of last object update" do 
    AlnResource.should have_attribute(:updated_at, :datetime)
  end

  it "should include a string name of aln_resource" do 
    AlnResource.should have_attribute(:resource_name, :string)
  end

  it "should include an intger identifying depth supoort hierarchy relative to aln_resource" do 
    AlnResource.should have_attribute(:support_hierarchy_depth, :integer)
  end

end
