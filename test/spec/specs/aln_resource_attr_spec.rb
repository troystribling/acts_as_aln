require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
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

##########################################################################################################
describe "attribute identifying support hierarchy depth" do

  before(:each) do
    AlnResource.new(model_data[:aln_resource]).save
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    AlnResource.find_support_root_by_model(AlnResource, :first).destroy   
  end

  it "should be 0 for no supported" do
    @root.depth.should eql(0)
  end

  it "should increment to 1 when first supported with no supported is added" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)    
  end

  it "should remain 1 as additional supported with no supported are added" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
  end

  it "should remain 1 when a supported with no supported is destroyed and more than 1 supported with no supported remain" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    @root.destroy_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.name = '#{model_data[:aln_termination_supported_1]['name']}'")
    @root.depth.should eql(1)
  end

  it "should become 0 if all supported are destroyed" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    @root.destroy_supported
    @root.depth.should eql(0)
  end

  it "should increment by 1 when another layer of supported is added" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    @root.supported[0] << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(2)
    @root.supported[0]  << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(2)
  end

  it "should decrement by 1 when the layer of supported removed" do
    @root.depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(1)
    @root.supported[0] << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.supported[0] << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.depth.should eql(2)
    @root.supported[0].destroy_supported
    @root.depth.should eql(1)
    @root.destroy_supported
    @root.depth.should eql(0)
  end
  
  it "should increment by 1 as each layer of supported is added" do
    @root.depth.should eql(0)
    @root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.depth.should eql(1)
    @root.supported[0] << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.depth.should eql(2)
    @root.supported[0].supported[0] << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.supported[0].supported[0].supported[0].depth.should eql(0)
    @root.supported[0].supported[0].depth.should eql(1)
    @root.supported[0].depth.should eql(2)
    @root.depth.should eql(3)
    @root.save_hierarchy
    AlnResource.find_support_root_by_model(AlnResource, :first).depth.should eql(3) 
    AlnResource.find_support_root_by_model(AlnResource, :first).supported[0].depth.should eql(2) 
    AlnResource.find_support_root_by_model(AlnResource, :first).supported[0].supported[0].depth.should eql(1) 
    AlnResource.find_support_root_by_model(AlnResource, :first).supported[0].supported[0].supported[0].depth.should eql(0) 
  end

  it "should decrement by 1 as each layer of supported is removed" do
    @root.depth.should eql(0)
    @root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.depth.should eql(1)
    @root.supported[0] << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.depth.should eql(2)
    @root.supported[0].supported[0] << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.supported[0].supported[0].supported[0].depth.should eql(0)
    @root.supported[0].supported[0].depth.should eql(1)
    @root.supported[0].depth.should eql(2)
    @root.depth.should eql(3)
    @root.supported[0].supported[0].destroy_supported
    @root.supported[0].supported[0].depth.should eql(0)
    @root.supported[0].depth.should eql(1)
    @root.depth.should eql(2)
    @root.supported[0].destroy_supported
    @root.supported[0].depth.should eql(0)
    @root.depth.should eql(1)
    @root.destroy_supported
    @root.depth.should eql(0)
  end

  
end

