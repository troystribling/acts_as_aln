require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "support hierarchy depth when support hierarchy consists only of root", :shared => true do

  it "should be 0" do
    @root.support_hierarchy_depth.should eql(0)
  end
  
end

#########################################################################################################
describe "support hierarchy depth when support hierarchy has a depth of 1", :shared => true do

  it "should increment to 1 when first supported with no supported is added" do
    @root.support_hierarchy_depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.support_hierarchy_depth.should eql(1)    
  end

  it "should remain 1 as additional supported with no supported are added" do
    @root.support_hierarchy_depth.should eql(0)
    @root << AlnResource.new(model_data[:aln_resource_supported_1])
    @root.support_hierarchy_depth.should eql(1)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.support_hierarchy_depth.should eql(1)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.support_hierarchy_depth.should eql(1)
  end

  it "should remain 1 when a supported with no supported is destroyed and more than 1 supported with no supported remain" do
    @root.support_hierarchy_depth.should eql(0)
    @root << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.support_hierarchy_depth.should eql(1)
    @root.destroy_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['resource_name']}'")
    @root.support_hierarchy_depth.should eql(1)
  end

  it "should become 0 if all supported are destroyed" do
    @root.support_hierarchy_depth.should eql(0)
    @root << [AlnResource.new(model_data[:aln_resource_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_1])]
    @root.support_hierarchy_depth.should eql(1)
    @root.destroy_supported
    @root.support_hierarchy_depth.should eql(0)
  end

end

#########################################################################################################
describe "support hierarchy depth when support hierarchy has a depth greater than 1", :shared => true do

  it "should increment by 1 when a supported with no supported is added" do
    @root.support_hierarchy_depth.should eql(1)
    @root.supported.first << AlnResource.new(model_data[:aln_resource_supported_1])
    @root.support_hierarchy_depth.should eql(2)
  end

  it "should not increment as additional supported with no supported are added" do
    @root.support_hierarchy_depth.should eql(1)
    @root.supported.first << AlnResource.new(model_data[:aln_resource_supported_1])
    @root.support_hierarchy_depth.should eql(2)
    @root.supported.first  << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.support_hierarchy_depth.should eql(2)
    @root.supported.last << AlnResource.new(model_data[:aln_resource_supported_1])
    @root.support_hierarchy_depth.should eql(2)
    @root.supported.last << AlnResource.new(model_data[:aln_resource_supported_1])
    @root.support_hierarchy_depth.should eql(2)
  end

  it "should not decrement when a supported with no supported is destroyed and more than 1 supported with no supported remain" do
    @root.support_hierarchy_depth.should eql(1)
    @root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    @root.support_hierarchy_depth.should eql(2)
    @root.supported.first.destroy_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['resource_name']}'")
    @root.support_hierarchy_depth.should eql(2)
  end

  it "should decrement by 1 when all supported are destroyed" do
    @root.support_hierarchy_depth.should eql(1)
    @root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    @root.support_hierarchy_depth.should eql(2)
    @root.supported.first.destroy_supported
    @root.support_hierarchy_depth.should eql(1)
  end
  
  it "should increment total hierarchy depth when a supported with supported is added to a deepest leaf by added hierarchy depth + 1" do
    @root.support_hierarchy_depth.should eql(1)
    added_root = AlnResource.new(model_data[:aln_resource])
    added_root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    added_root.supported.first << AlnResource.new(model_data[:aln_resource_supported_1])
    added_root.support_hierarchy_depth.should eql(2)
    @root.supported.first << added_root
    @root.support_hierarchy_depth.should eql(4)    
  end

  it "should not increment total support hierarchy depth when a supported with supported is added that does not increase total depth" do
    @root.support_hierarchy_depth.should eql(1)
    deep_root = AlnResource.new(model_data[:aln_resource])
    deep_root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    deep_root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    deep_root.supported.first.supported.last << AlnTermination.new(model_data[:aln_termination_supported_1])
    deep_root.support_hierarchy_depth.should eql(3)
    @root.supported.first << deep_root
    @root.support_hierarchy_depth.should eql(5)    
    shallow_root = AlnResource.new(model_data[:aln_resource])
    shallow_root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    shallow_root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    shallow_root.support_hierarchy_depth.should eql(2)
    @root.supported.last << shallow_root
    @root.support_hierarchy_depth.should eql(5)    
  end

  it "should decrement total hierarchy depth when a supported with supported where this supported had increased the total hierarchy depth by its hierarchy depth + 1" do
    @root.support_hierarchy_depth.should eql(1)
    added_root = AlnResource.new(model_data[:aln_resource])
    added_root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    added_root.supported.first << AlnResource.new(model_data[:aln_resource_supported_1])
    added_root.support_hierarchy_depth.should eql(2)
    @root.supported.first << added_root
    @root.support_hierarchy_depth.should eql(4)    
    @root.supported.first.destroy_supported
    @root.support_hierarchy_depth.should eql(1)    
  end


  it "should not decrement total hierarchy depth when a supported with supported is destroyed that does not decrease total depth" do
    @root.support_hierarchy_depth.should eql(1)
    deep_root = AlnResource.new(model_data[:aln_resource])
    deep_root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    deep_root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    deep_root.supported.first.supported.last << AlnTermination.new(model_data[:aln_termination_supported_1])
    deep_root.support_hierarchy_depth.should eql(3)
    @root.supported.first << deep_root
    @root.support_hierarchy_depth.should eql(5)    
    shallow_root = AlnResource.new(model_data[:aln_resource])
    shallow_root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    shallow_root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    shallow_root.support_hierarchy_depth.should eql(2)
    @root.supported.last << shallow_root
    @root.support_hierarchy_depth.should eql(5)    
    @root.supported.last.destroy_supported
    @root.support_hierarchy_depth.should eql(5)    
  end

end

###########################################################################################################
describe "support hierarchy depth decrement for aln_resource destroy methods", :shared => true do

  def build_test_hierarchy 
    @root.support_hierarchy_depth.should eql(1)
    @added_root = AlnResource.new(model_data[:aln_resource])
    @added_root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_1])]
    @added_root.supported.first << AlnResource.new(model_data[:aln_resource_supported_1])
    @added_root.support_hierarchy_depth.should eql(2)
  end
  
  def add_to_aln_resource_leaf
    @root.supported.last << @added_root
    @root.support_hierarchy_depth.should eql(4)    
  end

  def add_to_aln_termination_leaf
    @root.supported.first << @added_root
    @root.support_hierarchy_depth.should eql(4)    
  end

  it "should be support hierachy depth of destroyed support hierarchy for AlnResource#destroy_supported when supporter is aln_termination" do
    build_test_hierarchy
    add_to_aln_termination_leaf
    @root.supported.first.destroy_supported
    @root.support_hierarchy_depth.should eql(1)    
  end

  it "should be support hierachy depth of destroyed support hierarchy for AlnResource#destroy_supported when supporter is aln_resource" do
    build_test_hierarchy
    add_to_aln_resource_leaf
    @root.supported.last.destroy_supported
    @root.support_hierarchy_depth.should eql(1)    
  end

  it "should be support hierachy depth of destroyed support hierarchy for AlnResource#destroy_supported_by_model when supporter is aln_termination" do
    build_test_hierarchy
    add_to_aln_termination_leaf
    @root.destroy_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_1]['resource_name']}'")
    @root.support_hierarchy_depth.should eql(1)    
  end

  it "should be support hierachy depth of destroyed support hierarchy for AlnResource#destroy_supported_by_model when supporter is aln_resource" do
    build_test_hierarchy
    add_to_aln_resource_leaf
    @root.destroy_supported_by_model(AlnResource, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_resource_supported_2]['resource_name']}'")
    @root.support_hierarchy_depth.should eql(1)    
  end

  it "should be support hierachy depth of destroyed support hierarchy for AlnResource#destroy_support_hierarchy when supporter is aln_termination" do
    build_test_hierarchy
    add_to_aln_termination_leaf
    @root.supported.first.supported.first.destroy_support_hierarchy
    @root.support_hierarchy_depth.should eql(1)    
    @root.supported.first.supported.length.should eql(0)    
    @root.supported.length.should eql(2)    
  end

  it "should be support hierachy depth of destroyed support hierarchy for AlnResource#destroy_support_hierarchy when supporter is aln_resource" do
    build_test_hierarchy
    add_to_aln_resource_leaf
    @root.supported.last.supported.first.destroy_support_hierarchy
    @root.support_hierarchy_depth.should eql(1)    
    @root.supported.last.supported.length.should eql(0)    
    @root.supported.length.should eql(2)    
  end

end

###########################################################################################################
describe "persistance of support hierarchy depth for depth of 1", :shared => true do

  it "should be possible to increase depth of persistent support hierarchy when hierarchy depth is 0" do
    @root.support_hierarchy_depth.should eql(0)
    @root << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.support_hierarchy_depth.should eql(1)
  end
  
end


###########################################################################################################
describe "persistence of support hierarchy depth for depth greater than 1", :shared => true do

  it "should be possible to increase depth of persistent support hierarchy when hierarchy depth is 1" do
    @root.support_hierarchy_depth.should eql(1)
    @root.supported.first.support_hierarchy_depth.should eql(0)
    @root.supported.first << AlnTermination.new(model_data[:aln_termination_supported_1])
    @root.support_hierarchy_depth.should eql(2)
    @root.supported.first.support_hierarchy_depth.should eql(1)
  end
  
end

############################################################################################################
describe "support hierarchy depth accessed from aln_resource descendant root when depth is 1" do

  before(:each) do
    AlnResource.new(model_data[:aln_resource]).save
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    @root.destroy   
  end

  it_should_behave_like "support hierarchy depth when support hierarchy consists only of root"  
  
  it_should_behave_like "support hierarchy depth when support hierarchy has a depth of 1"

  it_should_behave_like "persistance of support hierarchy depth for depth of 1"

end

##########################################################################################################
describe "support hierarchy depth accessed from aln_resource descendant root when depth is 1" do

  before(:each) do
    AlnResource.new(model_data[:aln_resource]).save
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    @root.destroy   
  end

  it_should_behave_like "support hierarchy depth when support hierarchy consists only of root"  

  it_should_behave_like "support hierarchy depth when support hierarchy has a depth of 1"

  it_should_behave_like "persistance of support hierarchy depth for depth of 1"
  
end

###########################################################################################################
describe "support hierarchy depth accessed from aln_resource descendant root when depth is greater than 1" do

  before(:each) do
    root_tmp = AlnResource.new(model_data[:aln_resource])
    root_tmp << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root_tmp.save_hierarchy
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    @root.destroy   
  end

  it_should_behave_like "support hierarchy depth when support hierarchy has a depth greater than 1"

  it_should_behave_like "persistence of support hierarchy depth for depth greater than 1"  
  
  it_should_behave_like "support hierarchy depth decrement for aln_resource destroy methods"
  
end

##########################################################################################################
describe "support hierarchy depth accessed from aln_resource descendant root when depth is greater than 1" do

  before(:each) do
    root_tmp = AlnTermination.new(model_data[:aln_termination])
    root_tmp << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root_tmp.save_hierarchy
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:each) do
    @root.destroy   
  end

  it_should_behave_like "support hierarchy depth when support hierarchy has a depth greater than 1"

  it_should_behave_like "persistence of support hierarchy depth for depth greater than 1"  

  it_should_behave_like "support hierarchy depth decrement for aln_resource destroy methods"
  
end
