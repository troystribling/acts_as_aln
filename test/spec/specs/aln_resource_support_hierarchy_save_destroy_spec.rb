require File.dirname(__FILE__) + '/../spec_helper'

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

