require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "attributes indentifying model update time and create time" do

  before(:all) do
    @r = AlnResource.new(:resource_name => model_data[:aln_resource][:resource_name])
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
    @r = AlnResource.new(:resource_name => model_data[:aln_resource][:resource_name])
  end

  it "should identify name of aln_resource as string" do 
    @r.resource_name.should eql(model_data[:aln_resource][:resource_name])
  end
  
end

##########################################################################################################
describe "attribute identifying support hierarchy depth", :shared => true do
#
#  it "should be 0 for no supported" do
#    @root.hierarchy_depth.should eql(0)
#  end
#
#  it "should increment to 1 when first supported with no supported is added" do
#    @root.hierarchy_depth.should eql(0)
#    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.hierarchy_depth.should eql(1)    
#  end
#
#  it "should remain 1 as additional supported with no supported are added" do
#    @root.hierarchy_depth.should eql(0)
#    @root << AlnResource.new(model_data[:aln_resource_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.hierarchy_depth.should eql(1)
#  end
#
#  it "should remain 1 when a supported with no supported is destroyed and more than 1 supported with no supported remain" do
#    @root.hierarchy_depth.should eql(0)
#    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root << AlnResource.new(model_data[:aln_resource_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root.destroy_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['name']}'")
#    @root.hierarchy_depth.should eql(1)
#  end
#
#  it "should become 0 if all supported are destroyed" do
#    @root.hierarchy_depth.should eql(0)
#    @root << AlnResource.new(model_data[:aln_resource_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root.destroy_supported
#    @root.hierarchy_depth.should eql(0)
#  end
#
#  it "should increment by 1 when another layer of supported is added" do
#    @root.hierarchy_depth.should eql(0)
#    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root << AlnResource.new(model_data[:aln_resource_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root.supported.first << AlnResource.new(model_data[:aln_resource_supported_1])
#    @root.hierarchy_depth.should eql(2)
#    @root.supported.first  << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.hierarchy_depth.should eql(2)
#  end
#
#  it "should decrement by 1 when the layer of supported removed" do
#    @root.hierarchy_depth.should eql(0)
#    @root << AlnResource.new(model_data[:aln_resource_supported_1])
#    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.hierarchy_depth.should eql(1)
#    @root.supported.first << AlnTermination.new(model_data[:aln_termination_supported_1])
#    @root.supported.first << AlnResource.new(model_data[:aln_resource_supported_1])
#    @root.hierarchy_depth.should eql(2)
#    @root.supported.first.destroy_supported
#    @root.hierarchy_depth.should eql(1)
#    @root.destroy_supported
#    @root.hierarchy_depth.should eql(0)
#  end
#  
#  it "should increment by 1 as each layer of supported is added" do
#    @root.hierarchy_depth.should eql(0)
#    @root << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    @root.hierarchy_depth.should eql(1)
#    @root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
#    @root.hierarchy_depth.should eql(2)
#    @root.supported.first.supported.first << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    @root.supported.first.supported.first.supported.first.hierarchy_depth.should eql(0)
#    @root.supported.first.supported.first.hierarchy_depth.should eql(1)
#    @root.supported.first.hierarchy_depth.should eql(2)
#    @root.hierarchy_depth.should eql(3)
#    @root.save_hierarchy
#    @root.class.find_support_root_by_model(@root.class, :first).hierarchy_depth.should eql(3) 
#    @root.class.find_support_root_by_model(@root.class, :first).supported.first.hierarchy_depth.should eql(2) 
#    @root.class.find_support_root_by_model(@root.class, :first).supported.first.supported.first.hierarchy_depth.should eql(1) 
#    @root.class.find_support_root_by_model(@root.class, :first).supported.first.supported.first.supported.first.hierarchy_depth.should eql(0) 
#  end
#
#  it "should decrement by 1 as each layer of supported is removed" do
#    @root.hierarchy_depth.should eql(0)
#    @root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    @root.hierarchy_depth.should eql(1)
#    @root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    @root.hierarchy_depth.should eql(2)
#    @root.supported.first.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    @root.supported.first.supported.first.supported.first.hierarchy_depth.should eql(0)
#    @root.supported.first.supported.first.hierarchy_depth.should eql(1)
#    @root.supported.first.hierarchy_depth.should eql(2)
#    @root.hierarchy_depth.should eql(3)
#    @root.supported.first.supported.first.destroy_supported
#    @root.supported.first.supported.first.hierarchy_depth.should eql(0)
#    @root.supported.first.hierarchy_depth.should eql(1)
#    @root.hierarchy_depth.should eql(2)
#    @root.supported.first.destroy_supported
#    @root.supported.first.hierarchy_depth.should eql(0)
#    @root.hierarchy_depth.should eql(1)
#    @root.destroy_supported
#    @root.hierarchy_depth.should eql(0)
#  end
#
  it "should be persistent" do
    @root.hierarchy_depth.should eql(0)
    @root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.hierarchy_depth.should eql(1)
    @root.save_hierarchy
    root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
    root_chk.hierarchy_depth.should eql(1)
    root_chk << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    root_chk.hierarchy_depth.should eql(1)
    root_chk.save_hierarchy
    root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
    root_chk.hierarchy_depth.should eql(1)
    root_chk.supported.first.hierarchy_depth.should eql(0)
    puts "adding second layer"
    root_chk.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
p root_chk
p root_chk.object_id
p root_chk.supported.first.supporter.object_id
root_chk.supported.each {|s| puts "#{s.resource_name},#{s.supporter.id}"}
    root_chk.hierarchy_depth.should eql(2)
    root_chk.supported.first.hierarchy_depth.should eql(1)
  end
  
end

###########################################################################################################
describe "attribute identifying support hierarchy depth accessed from aln_resource root" do

  before(:each) do
    AlnResource.new(model_data[:aln_resource]).save
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    AlnResource.find_support_root_by_model(AlnResource, :first).destroy   
  end

  it_should_behave_like "attribute identifying support hierarchy depth"  

end

##########################################################################################################
describe "attribute identifying support hierarchy depth accessed from aln_resource descendant root" do

  before(:each) do
    AlnTermination.new(model_data[:aln_termination]).save
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:each) do
    AlnTermination.find_support_root_by_model(AlnTermination, :first).destroy   
  end

  it_should_behave_like "attribute identifying support hierarchy depth"  
  
end
