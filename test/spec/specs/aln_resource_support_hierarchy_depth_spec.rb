require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
#describe "support hierarchy depth when support hierarchy consists only of root", :shared => true do
#
#  it "should be 0" do
#    @root.hierarchy_depth.should eql(0)
#  end
#  
#end
#
##########################################################################################################
#describe "support hierarchy depth when support hierarchy has a depth of 1", :shared => true do
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
#end

#describe "support hierarchy depth when support hierarchy has a depth greater than 1", :shared => true do
#
#  it "should increment by 1 when a supported with no supported is added to a leaf of a hierarchy with depth 1" do
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
#  it "should decrement by 1 when the final leaf at depth 2 is removed from a support hierarchy with depth 2" do
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
#
#end

#describe "persistance of support hierarchy depth when support hierarchy has a depth of 1", :shared => true do
#
#  it "should be possible to update hierachy root, save hierarchy then retrieve hiearchy depth from root" do
#    @root.support_hierarchy_depth.should eql(0)
#    @root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    @root.support_hierarchy_depth.should eql(1)
#    @root.save_hierarchy
#    root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
#    root_chk.support_hierarchy_depth.should eql(1)
#    root_chk << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    root_chk.support_hierarchy_depth.should eql(1)
#  end
#  
#end
#

describe "persistance of support hierarchy depth when support hierarchy has a depth greater than 1", :shared => true do

  it "should be possible to update hierachy root, save hierarchy then retrieve hiearchy depth from root" do
    @root.support_hierarchy_depth.should eql(1)
    @root.supported.first.support_hierarchy_depth.should eql(0)
puts "adding second layer"
    @root.supported.first << AlnTermination.new(model_data[:aln_termination_supported_1])
#p @root
puts "root: #{@root.object_id}"
puts "root.supported.first.supporter: #{@root.supported.first.supporter.object_id}"
#p root_chk.supported.first.supporter.object_id
#root_chk.supported.each {|s| puts "#{s.resource_name},#{s.supporter.id}"}
#    root_chk.support_hierarchy_depth.should eql(2)
#    root_chk.supported.first.support_hierarchy_depth.should eql(1)
  end
  
end

############################################################################################################
#describe "attribute identifying support hierarchy depth accessed from aln_resource root" do
#
#  before(:each) do
#    AlnResource.new(model_data[:aln_resource]).save
#    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
#  end
#
#  after(:each) do
#    AlnResource.find_support_root_by_model(AlnResource, :first).destroy   
#  end
#
#  it_should_behave_like "attribute identifying support hierarchy depth"  
#
#end
#
###########################################################################################################
describe "support hierarchy depth accessed from aln_resource descendant root when depth is grater than 1" do

  before(:each) do
    root_tmp = AlnResource.new(model_data[:aln_resource])
    root_tmp << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    root_tmp.save_hierarchy
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    @root.destroy   
  end

  it_should_behave_like "persistance of support hierarchy depth when support hierarchy has a depth greater than 1"  
  
end

##########################################################################################################
#describe "support hierarchy depth accessed from aln_resource descendant root when depth is grater than 1" do
#
#  before(:each) do
#    root_tmp = AlnTermination.new(model_data[:aln_termination])
#    root_tmp << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
#    root_tmp.save_hierarchy
#    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
#  end
#
#  after(:each) do
#    @root.destroy   
#  end
#
#  it_should_behave_like "persistance of support hierarchy depth when support hierarchy has a depth greater than 1"  
#  
#end
