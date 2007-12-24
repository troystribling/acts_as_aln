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

  it "should include an integer preordered tree parameter support_hierarchy_left" do 
    AlnResource.should have_attribute(:support_hierarchy_left, :integer)
  end

  it "should include an integer preordered tree parameter support_hierarchy_right" do 
    AlnResource.should have_attribute(:support_hierarchy_right, :integer)
  end

  it "should include id of support hierarchy root" do 
    AlnResource.should have_attribute(:support_hierarchy_root_id, :integer)
  end

  it "should include id of supporter" do 
    AlnResource.should have_attribute(:supporter_id, :integer)
  end

end

##########################################################################################################
describe "retrieval of aln_resource ancestor from aln_resource descendant model class" do

  it "should return aln_resource if model is aln_resource" do
    AlnResource.to_aln_resource(AlnResource.new(model_data[:aln_resource])).class.should eql(AlnResource) 
  end

  it "should return aln_resource if model is a descendant of aln_resource" do 
    AlnResource.to_aln_resource(AlnTermination.new(model_data[:aln_termination])).class.should eql(AlnResource) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{AlnResource.to_aln_resource(Array.new)}.should raise_error(NoMethodError) 
  end
  
end

##########################################################################################################
describe "retrieval of aln_resource supported from a model instance", :shared => true do

  it "should return aln_resource if model is aln_resource" do
    mod = @mod_class.new
    s = mod.supported_as_aln_resource(AlnResource.new(model_data[:aln_resource]))
    s.class.should eql(AlnResource)
    s.supporter.should eql(mod) 
  end

  it "should return aln_resource if model is a descendant of aln_resource" do 
    mod = @mod_class.new
    s = mod.supported_as_aln_resource(AlnTermination.new(model_data[:aln_termination]))
    s.class.should eql(AlnResource)
    s.supporter.should eql(mod) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{@mod_class.new.supported_as_aln_resource(Array.new)}.should raise_error(PlanB::InvalidClass) 
  end
  
end

##########################################################################################################
describe "retrieval of aln_resource supported from an aln_resource model instance", :shared => true do

  before(:all) do
    @mod_class = AlnResource
  end
  
  it_should_behave_like "retrieval of aln_resource supported from a model instance"
  
end

##########################################################################################################
describe "retrieval of aln_resource supported from an aln_resource descendant model instance", :shared => true do

  before(:all) do
    @mod_class = AlnTermination
  end
  
  it_should_behave_like "retrieval of aln_resource supported from a model instance"
  
end
