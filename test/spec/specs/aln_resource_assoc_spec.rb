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
describe "aln_resource supported association creation and deletion" do

  it "should be able to add supported associations for aln_resource models" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_1]['name'])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_2]['name'])
  end

  it "should be able to add array of supported associations for aln_resource models" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_1]['name'])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_2]['name'])
  end

  it "should be able to remove a specified supported association for aln_resource models" do 
  end

  it "should be able to remove all supported associations for aln_resource models" do 
  end

  it "should be able to add supported associations for aln_resource decsendant models" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnTermination.new(model_data[:aln_termination_supported_1])
    root << AlnTermination.new(model_data[:aln_termination_supported_2])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_termination_supported_1]['name'])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_termination_supported_2]['name'])
  end

  it "should be able to add array of associations for aln_resource decsendant models" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2])]
    root.should have_supported_with_attribute_value(:name, model_data[:aln_termination_supported_1]['name'])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_termination_supported_2]['name'])
  end

  it "should be able to remove a specified supported association for aln_resource descendant models" do 
  end

  it "should be able to remove all supported associations for aln_resource descendant models" do 
  end

end

#########################################################################################################
describe "aln_resource supporter association creation and deletion" do
end

