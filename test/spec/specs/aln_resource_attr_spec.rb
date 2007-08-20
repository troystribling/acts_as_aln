require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "attributes indentifying model update time and create time" do

  before(:all) do
    @r = AlnResource.new(:name => model_data[:aln_resource][:name])
    @r.save
  end

  after(:all) do
    @r.destroy
  end 
  
  it "should identify date and time of model creation in database with created_at attribute" do 
    @r.created_at.class.should eql(Time)
  end

  it "should identify date and time of last object update in databasenwith updated_at attribute" do 
    @r.updated_at.class.should eql(Time)
  end
    
end

#########################################################################################################
describe "attributes identifying aln_resource models" do

  before(:all) do
    @r = AlnResource.new(:name => model_data[:aln_resource][:name])
  end

  it "should identify name of aln_resource as string" do 
    @r.name.should eql(model_data[:aln_resource][:name])
  end
  
end

#########################################################################################################
describe "attribute identifying support hierarchy depth" do

  before(:all) do
    @r = AlnResource.new(:name => model_data[:aln_resource][:name])
    @r.save
  end

  after(:all) do
    @r.destroy
  end

  before(:each) do
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    @root.save
  end

  it "should be 0 for are no supported" do
    @root.depth.should eql(0)
  end

  it "should increment to 1 when first supported with no supported is added" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)    
  end

  it "should remain 1 as additional supported with no supported are added" do
    @root.depth.should eql(1)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
  end

  it "should remain 1 when a supported with no supported is destroyed and more than 1 supported with no supported remain" do
    @root.depth.should eql(1)
    @root.destroy_supported(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    @root.depth.should eql(1)
  end

  it "should become 0 if all supported are destroyed" do
    @root.depth.should eql(1)
    @root.clear_supported
    @root.depth.should eql(0)
  end

  it "should increment by 1 for every layer of supported added" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    sup1 = @root.find_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    sup1 << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(2)
     sup1 << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(2)
    sup2 = sup1.find_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    sup2 << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(3)
  end

  it "should decrement by 1 for every layer of supported removed" do
    @root.depth.should eql(3)
    sup1 = @root.find_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    sup2 = sup1.find_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    sup2.clear_supported
    @root.depth.should eql(2)
    sup1.clear_supported
    @root.depth.should eql(1)
    @root.clear_supported
    @root.depth.should eql(0)
  end
  
end

