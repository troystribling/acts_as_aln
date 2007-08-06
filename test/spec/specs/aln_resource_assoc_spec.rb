require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_resource inheritance associations" do

  it "should declare descendant association" do 
    AlnResource.new().should declare_descendant_association
  end

  it "should have no ancestor" do 
    AlnResource.new().should_not declare_ancestor_association
  end
  
end

#########################################################################################################
describe "accessing aln_resource ancestor from descendant models" do

  it "should return class.self if model is aln_resource" do
    AlnResource.get_as_aln_resource(AlnResource.new(model_data[:aln_resource])).class.should eql(AlnResource) 
  end

  it "should return aln_resource if model is a descendant of aln_resource" do 
    AlnResource.get_as_aln_resource(AlnTermination.new(model_data[:aln_termination])).class.should eql(AlnResource) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{AlnResource.get_as_aln_resource(Array.new)}.should raise_error(PlanB::InvalidType) 
  end
  
end

#########################################################################################################
describe "query for root of support hierarcy" do

  it "should be able to retrieve the root of the hierarcy for aln_resource models" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save!
    root_chk = AlnResource.find_root
    root_chk.id.should eql(root.id)
    root_chk.should have_attributes_with_values(model_data[:aln_resource])
    root_chk.supporter.should be_nil
  end

  it "should be able to retrieve the root of the hierarcy for aln_resource descendant models" do 
    root = AlnTermination.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    loc_root.save
  end

end

#########################################################################################################
describe "supported lifecycle for aln_resource supporter" do

  before(:each) do
    root = AlnResource.new(model_data[:aln_resource])
    root.save
  end

  
  it "should be able to save supported aln_resource models with aln_resource supporter" do 
    root = AlnResource.find_root
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    loc_root.save
  end

  it "should be able to save array of supported associations for aln_resource models" do 
    root = AlnResource.find_root
    root << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_1]['name'])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_2]['name'])
    root.supported.length.should eql(2)
  end

  it "should be able to delete a specified supported association for aln_resource model" do 
    root = AlnResource.find_root
    root << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
  end

  it "should be able to delete all supported associations for aln_resource models" do 
    root = AlnResource.find_root
    root << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
  end

  it "should be able to add supported associations for aln_resource decsendant models" do 
    root = AlnResource.find_root
    root << AlnTermination.new(model_data[:aln_termination_supported_1])
    root << AlnTermination.new(model_data[:aln_termination_supported_2])
  end

  it "should be able to add array of associations for aln_resource decsendant models" do 
    root = AlnResource.find_root
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2])]
  end

  it "should be able to remove a specified supported association for aln_resource descendant models" do 
    root = AlnResource.find_root
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2])]
  end

  it "should be able to remove all supported associations for aln_resource descendant models" do 
    root = AlnResource.find_root
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2])]
  end

end

#########################################################################################################
describe "supported lifecycle for aln_resource descendant supporter" do
end

#########################################################################################################
describe "queries for supported models from supporter aln_resource" do

  before(:all) do
    @root = AlnResource.new(model_data[:aln_resource])
    @root << [
              AlnResource.new(model_data[:aln_resource_supported_1]),
              AlnResource.new(model_data[:aln_resource_supported_2]),
              AlnResource.new(model_data[:aln_resource_supported_3]),
              AlnTermination.new(model_data[:aln_termination_supported_1]),
              AlnTermination.new(model_data[:aln_termination_supported_2]),
              AlnTermination.new(model_data[:aln_termination_supported_3])
             ]
  end

end

#########################################################################################################
describe "queries for supported models from supporter aln_resource descendant" do
end

#########################################################################################################
describe "generation of supported query methods for aln_resource supporters" do
end

#########################################################################################################
describe "generation of supported query methods for aln_resource descendant supporters" do
end

#########################################################################################################
describe "aln_resource supporter lifecycle from aln_resource supported" do
end

#########################################################################################################
describe "aln_resource supporter lifecycle from aln_resource supported" do
end

#########################################################################################################
describe "supporter queries from aln_resource supported" do
end

#########################################################################################################
describe "supporter queries from aln_resource descendant supported" do
end
