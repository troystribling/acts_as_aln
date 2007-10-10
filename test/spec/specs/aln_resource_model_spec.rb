require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "aln_resource inheritance associations" do

  it "should declare descendant association" do 
    AlnResource.should declare_descendant_association
  end

  it "should have no ancestor" do 
    AlnResource.should_not declare_ancestor_association
  end
  
end

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

##########################################################################################################
describe "retrieval of aln_resource ancestor from aln_resource descendant model class" do

  it "should return aln_resource if model is aln_resource" do
    AlnResource.get_as_aln_resource(AlnResource.new(model_data[:aln_resource])).class.should eql(AlnResource) 
  end

  it "should return aln_resource if model is a descendant of aln_resource" do 
    AlnResource.get_as_aln_resource(AlnTermination.new(model_data[:aln_termination])).class.should eql(AlnResource) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{AlnResource.get_as_aln_resource(Array.new)}.should raise_error(PlanB::InvalidClass) 
  end
  
end

##########################################################################################################
describe "retrieval of aln_resource supported from a model instance" do

  it "should return aln_resource if model is aln_resource" do
    AlnResource.new.supported_as_aln_resource(AlnResource.new(model_data[:aln_resource])).class.should eql(AlnResource) 
  end

  it "should return aln_resource if model is a descendant of aln_resource" do 
    AlnResource.new.supported_as_aln_resource(AlnTermination.new(model_data[:aln_termination])).class.should eql(AlnResource) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{AlnResource.new.supported_as_aln_resource(Array.new)}.should raise_error(PlanB::InvalidClass) 
  end
  
end
