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
describe "supported lifecycle with aln_resource supporter and aln_resource supported" do

  it "should save and destroy supported when supporter is saved and destroyed" do 
    root = AlnResource.new(model_data[:aln_resource])
    s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    root << s1
    root.save    
    AlnResource.should exist(root.id) 
    AlnResource.should exist(s1.id)   
    root.destroy
    AlnResource.should_not exist(root.id) 
    AlnResource.should_not exist(s1.id)   
  end

  it "should save and destroy array of supported models when supporter is saved and destroyed" do 
    root = AlnResource.new(model_data[:aln_resource])
    s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    s2 = AlnResource.new(model_data[:aln_resource_supported_2])
    root << [s1, s2]
    root.save    
    AlnResource.should exist(s1.id)   
    AlnResource.should exist(s2.id)   
    root.destroy
    AlnResource.should_not exist(s1.id)   
    AlnResource.should_not exist(s2.id)   
  end

  it "should be able to delete a specified supported model without deleting supporter or other supported" do 
    root = AlnResource.new(model_data[:aln_resource])
    s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    root << [s1, s2]
    root.save    
    AlnResource.should exist(s1.id)   
    AlnResource.should exist(s2.id)   
    root.destroy_supported("name = '#{model_data[:aln_resource_supported_1]['name']}'")
    AlnResource.should_not exist(s1.id)   
    AlnResource.should exist(s2.id)   
    root.destroy
  end

  it "should be able to delete multiple specified supported models without deleting supporter or unintended supported" do 
    root = AlnResource.new(model_data[:aln_resource])
    s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    s3 = AlnResource.new(model_data[:aln_resource_supported_2])
    root << [s1, s2, s3]
    root.save    
    AlnResource.should exist(s1.id)   
    AlnResource.should exist(s2.id)   
    AlnResource.should exist(s3.id)   
    root.destroy_all_supported("name = '#{model_data[:aln_resource_supported_1]['name']}'")
    AlnResource.should_not exist(s1.id)   
    AlnResource.should_not exist(s2.id)   
    AlnResource.should exist(s3.id)   
    root.destroy
  end

  it "should be able to delete all supported models without deleting supporter" do 
    root = AlnResource.new(model_data[:aln_resource])
    s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    s3 = AlnResource.new(model_data[:aln_resource_supported_2])
    root << [s1, s2, s3]
    root.save    
    AlnResource.should exist(s1.id)   
    AlnResource.should exist(s2.id)   
    AlnResource.should exist(s3.id)   
    root.clear_supported
    AlnResource.should_not exist(s1.id)   
    AlnResource.should_not exist(s2.id)   
    AlnResource.should_not exist(s3.id)   
    root.destroy
  end

end

#########################################################################################################
describe "supported lifecycle with aln_resource descendant supporter and aln_resource descendant supported" do

  it "should save and destroy supported when supporter is saved and destroyed" do 
    root = AlnTermination.new(model_data[:aln_termination])
    s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    root << s1
    root.save    
    AlnTermination.should exist(root.id) 
    AlnTermination.should exist(s1.id)   
    root.destroy
    AlnTermination.should_not exist(root.id) 
    AlnTermination.should_not exist(s1.id)   
  end

  it "should save and destroy array of supported models when supporter is saved and destroyed" do 
    root = AlnTermination.new(model_data[:aln_resource])
    s1 = AlnTermination.new(model_data[:aln_resource_supported_1])
    s2 = AlnTermination.new(model_data[:aln_resource_supported_2])
    root << [s1, s2]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should_not exist(s2.id)   
  end

  it "should be able to delete a specified supported model without deleting supporter or other supported" do 
    root = AlnTermination.new(model_data[:aln_resource])
    s1 = AlnTermination.new(model_data[:aln_resource_supported_1])
    s2 = AlnTermination.new(model_data[:aln_resource_supported_1])
    root << [s1, s2]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy_supported("name = '#{model_data[:aln_resource_supported_1]['name']}'")
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy
  end

  it "should be able to delete multiple specified supported models without deleting supporter or unintended supported" do 
    root = AlnTermination.new(model_data[:aln_resource])
    s1 = AlnTermination.new(model_data[:aln_resource_supported_1])
    s2 = AlnTermination.new(model_data[:aln_resource_supported_1])
    s3 = AlnTermination.new(model_data[:aln_resource_supported_2])
    root << [s1, s2, s3]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    AlnTermination.should exist(s3.id)   
    root.destroy_all_supported("name = '#{model_data[:aln_resource_supported_1]['name']}'")
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should_not exist(s2.id)   
    AlnTermination.should exist(s3.id)   
    root.destroy
  end

  it "should be able to delete all supported models without deleting supporter" do 
    root = AlnTermination.new(model_data[:aln_resource])
    s1 = AlnTermination.new(model_data[:aln_resource_supported_1])
    s2 = AlnTermination.new(model_data[:aln_resource_supported_1])
    s3 = AlnTermination.new(model_data[:aln_resource_supported_2])
    root << [s1, s2, s3]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    AlnTermination.should exist(s3.id)   
    root.clear_supported
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should_not exist(s2.id)   
    AlnTermination.should_not exist(s3.id)   
    root.destroy
  end

end

#########################################################################################################
describe "query for root of support hierarcy" do

  it "should be able to find root when root is aln_resource model" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnResource.find_root.first
    root_chk.id.should eql(root.id)
    root_chk.should have_attributes_with_values(model_data[:aln_resource])
    root_chk.supporter.should be_nil
    root_chk.class.should eql(AlnResource)
    root_chk.destroy
  end

  it "should be able to find root when root aln_resource descendant model" do 
    root = AlnTermination.new(model_data[:aln_termination])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnTermination.find_root.first
    root_chk.id.should eql(root.id)
    root_chk.should have_attributes_with_values(model_data[:aln_termination])
    root_chk.supporter.should be_nil
    root_chk.class.should eql(AlnTermination)
    root_chk.destroy
  end

end

#########################################################################################################
describe "queries for supported aln_resource model attributes from supporter aln_resource" do

  before(:all) do
    @root = AlnResource.new(model_data[:aln_resource])
    @root << [
              AlnResource.new(model_data[:aln_resource_supported_1]),
              AlnResource.new(model_data[:aln_resource_supported_2]),
              AlnTermination.new(model_data[:aln_termination_supported_1]),
              AlnTermination.new(model_data[:aln_termination_supported_2]),
             ]
    @root.save
  end

  after(:all) do
    @root.destroy
  end
  
end

#########################################################################################################
describe "queries for supported aln_resource descendant model attributes from supporter aln_resource descendant" do

  before(:all) do
    @root = AlnTermination.new(model_data[:aln_resource])
    @root << [
              AlnResource.new(model_data[:aln_resource_supported_1]),
              AlnResource.new(model_data[:aln_resource_supported_2]),
              AlnTermination.new(model_data[:aln_termination_supported_1]),
              AlnTermination.new(model_data[:aln_termination_supported_2]),
             ]
    @root.save
  end

  after(:all) do
    @root.destroy
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
