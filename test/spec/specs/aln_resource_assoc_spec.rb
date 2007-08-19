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
describe "retrieval of aln_resource ancestor from descendant models" do

  it "should return class.self if model is aln_resource" do
    AlnResource.get_aln_resource_ancestor(AlnResource.new(model_data[:aln_resource])).class.should eql(AlnResource) 
  end

  it "should return aln_resource if model is a descendant of aln_resource" do 
    AlnResource.get_aln_resource_ancestor(AlnTermination.new(model_data[:aln_termination])).class.should eql(AlnResource) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource" do
    lambda{AlnResource.get_aln_resource_ancestor(Array.new)}.should raise_error(PlanB::InvalidType) 
  end
  
end

#########################################################################################################
describe "save and destroy when aln_resource is supporter and aln_resource is supported" do

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

  it "should delete a specified supported model without deleting supporter or other supported" do 
    root = AlnResource.new(model_data[:aln_resource])
    s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    root << [s1, s2]
    root.save    
    AlnResource.should exist(s1.id)   
    AlnResource.should exist(s2.id)   
    root.destroy_supported(AlnResource, :first, :conditions => "aln_resources.name = '#{model_data[:aln_resource_supported_1]['name']}'")
    AlnResource.should_not exist(s1.id)   
    AlnResource.should exist(s2.id)   
    root.destroy
  end

  it "should delete multiple specified supported models without deleting supporter or unintended supported" do 
    root = AlnResource.new(model_data[:aln_resource])
    s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    s3 = AlnResource.new(model_data[:aln_resource_supported_2])
    root << [s1, s2, s3]
    root.save    
    AlnResource.should exist(s1.id)   
    AlnResource.should exist(s2.id)   
    AlnResource.should exist(s3.id)   
    root.destroy_supported(AlnResource, :all, :conditions => "aln_resources.name = '#{model_data[:aln_resource_supported_1]['name']}'")
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
describe "save and destroy when aln_resource descendant is supporter and aln_resource descendant is supported" do

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
    root = AlnTermination.new(model_data[:aln_termination])
    s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    s2 = AlnTermination.new(model_data[:aln_termination_supported_2])
    root << [s1, s2]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should_not exist(s2.id)   
  end

  it "should delete a specified supported model using ancestor attribute without deleting supporter or other supported" do 
    root = AlnTermination.new(model_data[:aln_termination])
    s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    root << [s1, s2]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy_supported(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy
  end

  it "should delete multiple specified supported models using ancestor attribute without deleting supporter or unintended supported" do 
    root = AlnTermination.new(model_data[:aln_termination])
    s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    s3 = AlnTermination.new(model_data[:aln_termination_supported_2])
    root << [s1, s2, s3]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    AlnTermination.should exist(s3.id)   
    root.destroy_supported(AlnTermination, :all, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should_not exist(s2.id)   
    AlnTermination.should exist(s3.id)   
    root.destroy
  end

  it "should delete a specified supported model using model attribute without deleting supporter or other supported" do 
    root = AlnTermination.new(model_data[:aln_termination])
    s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    root << [s1, s2]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy_supported(AlnTermination, :first, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'")
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    root.destroy
  end

  it "should delete multiple specified supported models using model attribute without deleting supporter or unintended supported" do 
    root = AlnTermination.new(model_data[:aln_termination])
    s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    s3 = AlnTermination.new(model_data[:aln_termination_supported_2])
    root << [s1, s2, s3]
    root.save    
    AlnTermination.should exist(s1.id)   
    AlnTermination.should exist(s2.id)   
    AlnTermination.should exist(s3.id)   
    root.destroy_supported(AlnTermination, :all, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'")
    AlnTermination.should_not exist(s1.id)   
    AlnTermination.should_not exist(s2.id)   
    AlnTermination.should exist(s3.id)   
    root.destroy
  end

  it "should delete all supported models without deleting supporter" do 
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
describe "queries for supported models from aln_resource supporter" do

  before(:all) do
    @root = AlnResource.new(model_data[:aln_resource])
    @root << [
              AlnResource.new(model_data[:aln_resource_supported_1]),
              AlnResource.new(model_data[:aln_resource_supported_1]),
              AlnResource.new(model_data[:aln_resource_supported_2]),
              AlnTermination.new(model_data[:aln_termination_supported_1]),
              AlnTermination.new(model_data[:aln_termination_supported_1]),
              AlnTermination.new(model_data[:aln_termination_supported_2]),
             ]
    @root.save
  end

  after(:all) do
    @root.destroy
  end

  it "should return a single aln_resource supporter model when a condition on an aln_resource attribute is specified" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    root.find_supported(AlnResource, :first, :conditions => "aln_resources.name = '#{model_data[:aln_resource_supported_1]['name']}'").should \
      have_attributes_with_values(model_data[:aln_resource_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when a condition an aln_resource attribute is specified" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    root.find_supported(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when a condition an aln_resource descendant attribute is specified" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    root.find_supported(AlnTermination, :first, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when conditions on both aln_resource attributes and aln_resource descendant attributes are specified" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    root.find_supported(AlnTermination, :first, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}' and aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return all aln_resource supporter models as aln_resources models that match a condition on a specified aln_resource attribute" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    result = root.find_supported(AlnResource, :all, :conditions => "aln_resources.name = '#{model_data[:aln_resource_supported_1]['name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_resource_supported_1])
      r.class.should be(AlnResource)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match a condition on a specified aln_resource attribute" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    result = root.find_supported(AlnTermination, :all, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match a condition on a specified aln_resource descendant attribute" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    result = root.find_supported(AlnTermination, :all, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match specified conditions on both aln_resource attributes and aln_resource descendant attributes" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    result = root.find_supported(AlnTermination, :all, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}' and aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all supporters as aln_resource models" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    result = root.find_supported(AlnResource, :all)
    result.length.should eql(6)
    result.each do |r|
      r.class.should be(AlnResource)
    end
  end

  it "should return all aln_descendant supporters as specified model when supporters are models of different types" do 
    root = AlnResource.find_model_root(AlnResource, :first)
    result = root.find_supported(AlnTermination, :all)
    result.length.should eql(3)
    result.each do |r|
      r.class.should be(AlnTermination)
    end
  end

end

#########################################################################################################
describe "queries for supported models from aln_resource descendant supporter" do

  before(:all) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @root << [
              AlnResource.new(model_data[:aln_resource_supported_1]),
              AlnResource.new(model_data[:aln_resource_supported_1]),
              AlnResource.new(model_data[:aln_resource_supported_2]),
              AlnTermination.new(model_data[:aln_termination_supported_1]),
              AlnTermination.new(model_data[:aln_termination_supported_1]),
              AlnTermination.new(model_data[:aln_termination_supported_2]),
             ]
    @root.save
  end

  after(:all) do
    @root.destroy
  end

  it "should return a single aln_resource supporter model when a condition on an aln_resource attribute is specified" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    root.find_supported(AlnResource, :first, :conditions => "aln_resources.name = '#{model_data[:aln_resource_supported_1]['name']}'").should \
      have_attributes_with_values(model_data[:aln_resource_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when a condition an aln_resource attribute is specified" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    root.find_supported(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when a condition an aln_resource descendant attribute is specified" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    root.find_supported(AlnTermination, :first, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when conditions on both aln_resource attributes and aln_resource descendant attributes are specified" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    root.find_supported(AlnTermination, :first, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}' and aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return all aln_resource supporter models as aln_resources models that match a condition on a specified aln_resource attribute" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    result = root.find_supported(AlnResource, :all, :conditions => "aln_resources.name = '#{model_data[:aln_resource_supported_1]['name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_resource_supported_1])
      r.class.should be(AlnResource)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match a condition on a specified aln_resource attribute" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    result = root.find_supported(AlnTermination, :all, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match a condition on a specified aln_resource descendant attribute" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    result = root.find_supported(AlnTermination, :all, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match specified conditions on both aln_resource attributes and aln_resource descendant attributes" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    result = root.find_supported(AlnTermination, :all, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}' and aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all supporters as aln_resource models" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    result = root.find_supported(AlnResource, :all)
    result.length.should eql(6)
    result.each do |r|
      r.class.should be(AlnResource)
    end
  end

  it "should return all aln_descendant supporters as specified model when supporters are models of different types" do 
    root = AlnTermination.find_model_root(AlnTermination, :first)
    result = root.find_supported(AlnTermination, :all)
    result.length.should eql(3)
    result.each do |r|
      r.class.should be(AlnTermination)
    end
  end
  
end

#########################################################################################################
describe "supporter queries from aln_resource supported" do
end

#########################################################################################################
describe "supporter queries from aln_resource descendant supported" do
end

#########################################################################################################
describe "generation of supporter queries from aln_resource supported" do
end

#########################################################################################################
describe "generation of supporter queries from aln_resource descendant supported" do
end

#########################################################################################################
describe "generation of supported query methods for aln_resource supporters" do
end

#########################################################################################################
describe "generation of supported query methods for aln_resource descendant supporters" do
end

