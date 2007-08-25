require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "aln_resource inheritance associations" do

  it "should declare descendant association" do 
    AlnResource.new().should declare_descendant_association
  end

  it "should have no ancestor" do 
    AlnResource.new().should_not declare_ancestor_association
  end
  
end

#########################################################################################################
describe "retrieval of aln_resource ancestor from aln_resource descendant models" do

  it "should return aln_resource if model is aln_resource when retrieved from class" do
    AlnResource.aln_resource_ancestor(AlnResource.new(model_data[:aln_resource])).class.should eql(AlnResource) 
  end

  it "should return aln_resource if model is a descendant of aln_resource when retrieved from class" do 
    AlnResource.aln_resource_ancestor(AlnTermination.new(model_data[:aln_termination])).class.should eql(AlnResource) 
  end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource when retrieved from class" do
    lambda{AlnResource.aln_resource_ancestor(Array.new)}.should raise_error(PlanB::InvalidType) 
  end
  
end

#########################################################################################################
describe "supporter model and supported model lifecyle relations relative to supporter model", :shared => true do

  it "should save and destroy supported when supporter is saved and destroyed" do 
    @root << @s1
    @root.save    
    @root.class.should exist(@root.id) 
    @s1.class.should exist(@s1.id)   
    @root.destroy
    @root.class.should_not exist(@root.id) 
    @s1.class.should_not exist(@s1.id)   
  end

  it "should save and destroy array of supported models when supporter is saved and destroyed" do 
    @root << [@s1, @s2]
    @root.save    
    @s1.class.should exist(@s1.id)   
    @s2.class.should exist(@s2.id)   
    @root.class.should exist(@root.id) 
    @root.destroy
    @root.class.should_not exist(@root.id) 
    @s1.class.should_not exist(@s1.id)   
    @s2.class.should_not exist(@s2.id)   
  end

  it "should delete a specified supported model without deleting supporter or other supported" do 
    @root << [@s1, @s2]
    @root.save    
    @s1.class.should exist(@s1.id)   
    @s2.class.should exist(@s2.id)   
    @root.destroy_supported_by_model(@s1.class, :first, :conditions => "aln_resources.resource_name = '#{@s1.resource_name}'")
    @s1.class.should_not exist(@s1.id)   
    @s2.class.should exist(@s2.id)   
    @root.destroy
  end

  it "should delete multiple specified supported models without deleting supporter or unintended supported" do 
    @root << [@s1, @s2, @s3]
    @root.save    
    @s1.class.should exist(@s1.id)   
    @s2.class.should exist(@s2.id)   
    @s3.class.should exist(@s3.id)   
    @root.destroy_supported_by_model(@s1.class, :all, :conditions => "aln_resources.resource_name = '#{@s1.resource_name}'")
    @s1.class.should_not exist(@s1.id)   
    @s2.class.should_not exist(@s2.id)   
    @s3.class.should exist(@s3.id)   
    @root.destroy
  end

  it "should be able to delete all supported models without deleting supporter" do 
    @root << [@s1, @s2, @s3]
    @root.save    
    @s1.class.should exist(@s1.id)   
    @s2.class.should exist(@s2.id)   
    @s3.class.should exist(@s3.id)   
    @root.destroy_supported
    @s1.class.should_not exist(@s1.id)   
    @s2.class.should_not exist(@s2.id)   
    @s3.class.should_not exist(@s3.id)   
    @root.destroy
  end

end

#########################################################################################################
describe "save and destroy when aln_resource is supporter and aln_resource is supported" do

  before(:each) do
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s3 = AlnResource.new(model_data[:aln_resource_supported_2])
  end
  
  it_should_behave_like "supporter model and supported model lifecyle relations relative to supporter model"
  
end

#########################################################################################################
describe "save and destroy when aln_resource descendant is supporter and aln_resource descendant is supported" do

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s3 = AlnTermination.new(model_data[:aln_termination_supported_2])
  end
  
  it_should_behave_like "supporter model and supported model lifecyle relations relative to supporter model"

end

#########################################################################################################
describe "save and destroy when aln_resource is supporter and aln_resource descendant is supported" do

  before(:each) do
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s3 = AlnTermination.new(model_data[:aln_termination_supported_2])
  end
  
  it_should_behave_like "supporter model and supported model lifecyle relations relative to supporter model"

end

#########################################################################################################
describe "save and destroy when aln_resource descendant is supporter and aln_resource is supported" do

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s3 = AlnResource.new(model_data[:aln_resource_supported_2])
  end
  
  it_should_behave_like "supporter model and supported model lifecyle relations relative to supporter model"

end

##########################################################################################################
describe "queries for supported models from a supporter model", :shared => true do

  it "should return a single aln_resource supporter model when a condition on an aln_resource attribute is specified" do 
    @root_chk.find_supported_by_model(AlnResource, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_resource_supported_1]['resource_name']}'").should \
      have_attributes_with_values(model_data[:aln_resource_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when a condition an aln_resource attribute is specified" do 
    @root_chk.find_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['resource_name']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when a condition an aln_resource descendant attribute is specified" do 
    @root_chk.find_supported_by_model(AlnTermination, :first, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return a single aln_resource descendant supporter model when conditions on both aln_resource attributes and aln_resource descendant attributes are specified" do 
    @root_chk.find_supported_by_model(AlnTermination, :first, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}' and aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['resource_name']}'").should \
      have_attributes_with_values(model_data[:aln_termination_supported_1])
  end

  it "should return all aln_resource supporter models as aln_resources models that match a condition on a specified aln_resource attribute" do 
    result = @root_chk.find_supported_by_model(AlnResource, :all, :conditions => "aln_resources.resource_name = '#{model_data[:aln_resource_supported_1]['resource_name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_resource_supported_1])
      r.class.should be(AlnResource)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match a condition on a specified aln_resource attribute" do 
    result = @root_chk.find_supported_by_model(AlnTermination, :all, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['resource_name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match a condition on a specified aln_resource descendant attribute" do 
    result = @root_chk.find_supported_by_model(AlnTermination, :all, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all aln_resource descendant supporter models as specified model that match specified conditions on both aln_resource attributes and aln_resource descendant attributes" do 
    result = @root_chk.find_supported_by_model(AlnTermination, :all, :conditions => "aln_terminations.direction = '#{model_data[:aln_termination_supported_1]['direction']}' and aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['resource_name']}'")
    result.length.should be(2)
    result.each do |r|
      result.should have_attributes_with_values(model_data[:aln_termination_supported_1])
      r.class.should be(AlnTermination)
    end
  end

  it "should return all supporters as aln_resource models" do 
    result = @root_chk.find_supported_by_model(AlnResource, :all)
    result.length.should eql(6)
    result.each do |r|
      r.class.should be(AlnResource)
    end
  end

  it "should return all aln_descendant supporters as specified model when supporters are models of different types" do 
    result = @root_chk.find_supported_by_model(AlnTermination, :all)
    result.length.should eql(3)
    result.each do |r|
      r.class.should be(AlnTermination)
    end
  end

end

##########################################################################################################
describe "queries for supported models from aln_resource supporter model" do

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

  before(:each) do
    @root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
  end
  
  it_should_behave_like "queries for supported models from a supporter model"
  
end

##########################################################################################################
describe "queries for supported models from aln_resource descendant supporter model" do

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

  before(:each) do
    @root_chk = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end
  
  it_should_behave_like "queries for supported models from a supporter model"
  
end

##########################################################################################################
describe "queries for supporter model from supported model", :shared => true do

  it "should retrieve supporter as aln_resource when supported is aln_resource" do 
     supported = AlnResource.find_by_model(:first, :conditions=> "aln_resources.resource_name='#{model_data[:aln_resource_supported_1]['resource_name']}'")
     supported.find_supporter_by_model(AlnResource).attributes.should == AlnResource.aln_resource_ancestor(@supporter).attributes
  end

  it "should retrieve supporter as aln_resource when supported is aln_resource descendant" do 
     supported = AlnResource.find_by_model(:first, :conditions=> "aln_resources.resource_name='#{model_data[:aln_termination_supported_1]['resource_name']}'")
     supported.find_supporter_by_model(AlnResource).attributes.should == AlnResource.aln_resource_ancestor(@supporter).attributes
  end

end


##########################################################################################################
describe "queries for supporter model from supported for aln_resource supporter" do

  before(:all) do
    supporter = AlnResource.new(model_data[:aln_resource])
    supporter << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])] 
    supporter.save
  end

  after(:all) do
    supporter = AlnResource.find_support_root_by_model(AlnResource, :first)
    supporter.destroy
  end

  before(:each) do
    @supporter = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  it_should_behave_like "queries for supporter model from supported model"

end

##########################################################################################################
describe "queries for supporter model from supported for aln_resource descendant supporter" do

  before(:all) do
    supporter = AlnTermination.new(model_data[:aln_termination])
    supporter << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])] 
    supporter.save
  end

  after(:all) do
    supporter = AlnTermination.find_support_root_by_model(AlnTermination, :first)
    supporter.destroy
  end

  before(:each) do
    @supporter = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  it_should_behave_like "queries for supporter model from supported model"

  it "should retrieve supporter as aln_resource descendant when supported is aln_resource" do 
     supported = AlnResource.find_by_model(:first, :conditions=> "aln_resources.resource_name='#{model_data[:aln_resource_supported_1]['resource_name']}'")
     supported.find_supporter_by_model(AlnTermination).attributes.should == @supporter.attributes
  end

  it "should retrieve supporter as aln_resource descendant when supported is aln_resource descendant" do 
     supported = AlnResource.find_by_model(:first, :conditions=> "aln_resources.resource_name='#{model_data[:aln_termination_supported_1]['resource_name']}'")
     supported.find_supporter_by_model(AlnTermination).attributes.should == @supporter.attributes
  end

end

##########################################################################################################
describe "retrieval of supported aln_resource ancestor model from supporter", :shared => true do

  it "should return aln_resource if model is aln_resource when retrieved from supporter instance" do
    supported = @supporter.supported_as_aln_resource(AlnResource.new(model_data[:aln_resource]))
    supported.class.should be(AlnResource)
    supported.supporter.attributes.should == @supporter_aln_resource.attributes
    supported.supporter.object_id.should eql(@supporter_aln_resource.object_id)
  end

  it "should return aln_resource if model is a descendant of aln_resource when retrieved from supporter instance" do 
    supported = @supporter.supported_as_aln_resource(AlnTermination.new(model_data[:aln_termination]))
    supported.class.should be(AlnResource)
    supported.supporter.attributes.should == @supporter_aln_resource.attributes
    supported.supporter.object_id.should eql(@supporter_aln_resource.object_id)
   end

  it "should raise PlanB::InvalidType if model is not a descendant of aln_resource when retrieved from supporter instance" do
    lambda{@supporter.supported_as_aln_resource(Array.new)}.should raise_error(PlanB::InvalidType) 
  end
  
end

##########################################################################################################
describe "retrieval of supported aln_resource ancestor model from supporter aln_resource" do

  before(:each) do
    @supporter = AlnResource.new(model_data[:aln_resource])
    @supporter_aln_resource = @supporter
  end

  it_should_behave_like "retrieval of supported aln_resource ancestor model from supporter"

end

##########################################################################################################
describe "retrieval of supported aln_resource ancestor model from supporter aln_resource descendant" do

  before(:each) do
    @supporter = AlnTermination.new(model_data[:aln_termination])
    @supporter_aln_resource = @supporter.aln_resource
  end

  it_should_behave_like "retrieval of supported aln_resource ancestor model from supporter"

end

##########################################################################################################
describe "supporter model and supported model lifecyle relations relative to supported model" do

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @root << @s1
  end

  it "should save supporter when supported is saved" do 
   @s1.save
   @s1.class.should exist(@s1.id)
   @root.class.should exist(@root.id)
   @s1.destroy
   @root.destroy
  end

  it "should not destroy supporter when supported is destroyed" do 
   @root.save
   @s1.class.should exist(@s1.id)
   @root.class.should exist(@root.id)
   @s1.destroy
   @s1.class.should_not exist(@s1.id)
   @root.class.should exist(@root.id)
   @root.destroy
  end

end

##########################################################################################################
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

