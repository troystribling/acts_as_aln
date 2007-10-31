require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
module FindHierarchyHelper

  def verify_hierarchy_metadata(mods, mod_class, lr_data)
    mods.length.should eql(lr_data.length)
    (0..mods.length-1).each do |idx|
      mods[idx].support_hierarchy_left.should eql(lr_data[idx][0])
      mods[idx].support_hierarchy_right.should eql(lr_data[idx][1])
      mods[idx].class.should eql(mod_class)
    end
  end
  
end

##########################################################################################################
#describe "queries for root of support hierarcy" do
#
#  it "should find root when root is aln_resource model" do 
#    root = AlnResource.new(model_data[:aln_resource])
#    root << AlnResource.new(model_data[:aln_resource_supported_1])
#    root << AlnResource.new(model_data[:aln_resource_supported_2])
#    root.save
#    root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
#    root_chk.id.should be(root.id)
#    root_chk.class.should be(AlnResource)
#    root_chk.should have_attributes_with_values(model_data[:aln_resource])
#    root_chk.supporter.should be_nil
#    root_chk.destroy
#  end
#
#  it "should find root when root is an aln_resource descendant model" do 
#    root = AlnTermination.new(model_data[:aln_termination])
#    root << AlnResource.new(model_data[:aln_resource_supported_1])
#    root << AlnResource.new(model_data[:aln_resource_supported_2])
#    root.save
#    root_chk = AlnTermination.find_support_root_by_model(AlnTermination, :first)
#    root_chk.id.should be(root.id)
#    root_chk.class.should be(AlnTermination)
#    root_chk.should have_attributes_with_values(model_data[:aln_termination])
#    root_chk.supporter.should be_nil
#    root_chk.destroy
#  end
#
#  it "should find root as aln_resource when root is an aln_resource descendant model" do 
#    root = AlnTermination.new(model_data[:aln_termination])
#    root << AlnResource.new(model_data[:aln_resource_supported_1])
#    root << AlnResource.new(model_data[:aln_resource_supported_2])
#    root.save
#    root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
#    root_chk.id.should be(root.aln_resource.id)
#    root_chk.class.should be(AlnResource)
#    root_chk.to_descendant.should have_attributes_with_values(model_data[:aln_termination])
#    root_chk.supporter.should be_nil
#    root_chk.destroy
#  end
#
#  it "should find all roots when multiple aln_resource roots exist" do 
#    root = AlnResource.new(model_data[:aln_resource])
#    root << AlnResource.new(model_data[:aln_resource_supported_1])
#    root << AlnResource.new(model_data[:aln_resource_supported_1])
#    root.save
#    root = AlnResource.new(model_data[:aln_resource])
#    root << AlnResource.new(model_data[:aln_resource_supported_2])
#    root << AlnResource.new(model_data[:aln_resource_supported_2])
#    root.save
#    root_chk = AlnResource.find_support_root_by_model(AlnResource, :all)
#    root_chk.length.should be(2)
#    root_chk.each do |r|
#      r.should have_attributes_with_values(model_data[:aln_resource])
#      r.supporter.should be_nil
#      r.class.should be(AlnResource)
#      r.destroy
#    end
#  end
#
#  it "should find all roots as aln_resorce when multiple aln_resource descendant roots exist" do 
#    root = AlnTermination.new(model_data[:aln_termination])
#    root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    root.save
#    root = AlnTermination.new(model_data[:aln_termination])
#    root << AlnTermination.new(model_data[:aln_termination_supported_2])
#    root << AlnTermination.new(model_data[:aln_termination_supported_2])
#    root.save
#    root = AlnConnection.new(model_data[:aln_connection])
#    root << AlnResource.new(model_data[:aln_resource_supported_2])
#    root << AlnResource.new(model_data[:aln_resource_supported_2])
#    root.save
#    root_chk = AlnResource.find_support_root_by_model(AlnResource, :all)
#    root_chk.length.should be(3)
#    root_chk.each do |r|
#      r.should have_attributes_with_values(model_data[:aln_termination_resource]) if r.descendant.class.eql?(AlnTermination)
#      r.should have_attributes_with_values(model_data[:aln_connection_resource]) if r.descendant.class.eql?(AlnConnection)
#      r.supporter.should be_nil
#      r.class.should be(AlnResource)
#      r.destroy
#    end
#  end
#
#  it "should find all roots as specified descendant type when roots exist of multiple aln_resource descendant types" do 
#    root = AlnTermination.new(model_data[:aln_termination])
#    root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    root << AlnTermination.new(model_data[:aln_termination_supported_1])
#    root.save
#    root = AlnTermination.new(model_data[:aln_termination])
#    root << AlnTermination.new(model_data[:aln_termination_supported_2])
#    root << AlnTermination.new(model_data[:aln_termination_supported_2])
#    root.save
#    root_con = AlnConnection.new(model_data[:aln_connection])
#    root_con << AlnResource.new(model_data[:aln_resource_supported_2])
#    root_con << AlnResource.new(model_data[:aln_resource_supported_2])
#    root_con.save
#    root_chk = AlnTermination.find_support_root_by_model(AlnTermination, :all)
#    root_chk.length.should be(2)
#    root_chk.each do |r|
#      r.should have_attributes_with_values(model_data[:aln_termination])
#      r.supporter.should be_nil
#      r.class.should be(AlnTermination)
#      r.destroy
#    end
#    root_con.destroy
#  end
#
#end
#
##########################################################################################################
#describe "queries for directly supported from supporter", :shared => true do
#
#  it "should find all supported of specified return models as aln_reasource" do 
#    @root.supported.should have_attributes_with_values([model_data[:aln_termination_resource_supported_1], model_data[:aln_termination_resource_supported_2], model_data[:aln_resource_supported_1], model_data[:aln_resource_supported_2]])
#    @root.supported.should be_class(AlnResource)
#  end
#
#  it "should find first supported of specified model" do 
#    mod = @root.find_supported_by_model(AlnTermination, :first)
#    mod.should have_attributes_with_values(model_data[:aln_termination_supported_1])
#    mod.should be_class(AlnTermination)
#  end
#
#  it "should find first supported of specified model type that matches a specified attribute and return models as specified type" do 
#    mod = @root.find_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_2]['resource_name']}'")
#    mod.should have_attributes_with_values(model_data[:aln_termination_supported_2])
#    mod.should be_class(AlnTermination)
#  end
#
#  it "should find all supported of specified model type and return models as specified type" do 
#    mods = @root.find_supported_by_model(AlnTermination, :all)
#    mods.should have_attributes_with_values([model_data[:aln_termination_supported_1], model_data[:aln_termination_supported_2]])
#    mods.should be_class(AlnTermination)
#  end
#
#  it "should find all supported of specified model type that matches a specified condition and return models as specified type" do 
#    mods = @root.find_supported_by_model(AlnTermination, :all, :conditions => "aln_terminations.directionality = '#{model_data[:aln_termination_supported_2]['directionality']}'")
#    mods.should have_attributes_with_values([model_data[:aln_termination_supported_1], model_data[:aln_termination_supported_2]])
#    mods.should be_class(AlnTermination)
#  end
#  
#end
#
###########################################################################################################
#describe "queries for directly supported from aln_resource supporter" do
#
#  before(:each) do
#    root = AlnResource.new(model_data[:aln_resource])
#    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
#             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
#    root.save
#    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
#  end
#
#  after(:each) do
#    @root.destroy   
#  end
#  
#  it_should_behave_like "queries for directly supported from supporter"
#    
#end
#
###########################################################################################################
#describe "queries for directly supported from aln_resource descendant supporter" do
#
#  before(:each) do
#    root = AlnTermination.new(model_data[:aln_termination])
#    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
#             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
#    root.save
#    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
#  end
#
#  after(:each) do
#    @root.destroy   
#  end
#  
#  it_should_behave_like "queries for directly supported from supporter"
#  
#end
#
##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1", :shared => true  do

  it "should find first supported for aln_resource models" do
    mod = @root.find_in_support_hierarchy_by_model(AlnResource, :first) 
    mod.support_hierarchy_left.should eql(24)
    mod.support_hierarchy_right.should eql(41)
    mod.class.should eql(AlnResource)
  end

  it "should find first supported matching specified condition for aln_resource models" do
    mod = @root.find_in_support_hierarchy_by_model(AlnResource, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_resource_supported_1]['resource_name']}'") 
    mod.support_hierarchy_left.should eql(20)
    mod.support_hierarchy_right.should eql(21)
    mod.class.should eql(AlnResource)
  end

  it "should find first supported of the specified aln_resource descendant model" do 
    mod = @root.find_in_support_hierarchy_by_model(AlnTermination, :first) 
    mod.support_hierarchy_left.should eql(24)
    mod.support_hierarchy_right.should eql(41)
    mod.class.should eql(AlnTermination)
  end

  it "should find first supported matching specified condition for the specified aln_resource descendant model" do
    mod = @root.find_in_support_hierarchy_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_2]['resource_name']}'") 
    mod.support_hierarchy_left.should eql(22)
    mod.support_hierarchy_right.should eql(23)
    mod.class.should eql(AlnTermination)
  end
  
  it "should find all supported aln_resource models" do 
    mods = @root.find_in_support_hierarchy_by_model(AlnResource, :all)
    verify_hierarchy_metadata(mods, AlnResource, model_data[:find_by_model_aln_resource_depth_greater_than_1])
  end

  it "should find all supported matching specified condition for aln_resource models" do
    mods = @root.find_in_support_hierarchy_by_model(AlnResource, :all, :conditions => "aln_resources.resource_name = '#{model_data[:aln_resource_supported_1]['resource_name']}'") 
    verify_hierarchy_metadata(mods, AlnResource, model_data[:find_by_model_with_condition_aln_resource_depth_greater_1])
  end

  it "should find all supported of the specified aln_resource descendant models" do 
    mods = @root.find_in_support_hierarchy_by_model(AlnTermination, :all)
    verify_hierarchy_metadata(mods, AlnTermination, model_data[:find_by_model_aln_termination_depth_greater_than_1])
  end

  it "should find all supported matching specified condition for aln_resource descendant models" do
    mods = @root.find_in_support_hierarchy_by_model(AlnTermination, :all, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_2]['resource_name']}'") 
    verify_hierarchy_metadata(mods, AlnTermination, model_data[:find_by_model_with_condition_aln_termination_depth_greater_1])
  end

end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 1", :shared => true  do

  it "should find first supported for aln_resource models" do
    mod = @root.find_in_support_hierarchy_by_model(AlnResource, :first) 
    mod.support_hierarchy_left.should eql(8)
    mod.support_hierarchy_right.should eql(9)
    mod.class.should eql(AlnResource)
  end

  it "should find first supported matching specified condition for aln_resource models" do
    mod = @root.find_in_support_hierarchy_by_model(AlnResource, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_resource_supported_1]['resource_name']}'") 
    mod.support_hierarchy_left.should eql(4)
    mod.support_hierarchy_right.should eql(5)
    mod.class.should eql(AlnResource)
  end

  it "should find first supported of the specified aln_resource descendant model" do 
    mod = @root.find_in_support_hierarchy_by_model(AlnTermination, :first) 
    mod.support_hierarchy_left.should eql(8)
    mod.support_hierarchy_right.should eql(9)
    mod.class.should eql(AlnTermination)
  end

  it "should find first supported matching specified condition for aln_resource models" do
    mod = @root.find_in_support_hierarchy_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_2]['resource_name']}'") 
    mod.support_hierarchy_left.should eql(6)
    mod.support_hierarchy_right.should eql(7)
    mod.class.should eql(AlnTermination)
  end
  
  it "should find all supported aln_resource models" do 
    mods = @root.find_in_support_hierarchy_by_model(AlnResource, :all)
    verify_hierarchy_metadata(mods, AlnResource, model_data[:find_by_model_aln_resource_depth_1])
  end

  it "should find all supported matching specified condition for aln_resource models" do
    mods = @root.find_in_support_hierarchy_by_model(AlnResource, :all, :conditions => "aln_resources.resource_name = '#{model_data[:aln_resource_supported_1]['resource_name']}'") 
    verify_hierarchy_metadata(mods, AlnResource, model_data[:find_by_model_with_condition_aln_resource_depth_1])
  end

  it "should find all supported of the specified aln_resource descendant model" do 
    mods = @root.find_in_support_hierarchy_by_model(AlnTermination, :all)
    verify_hierarchy_metadata(mods, AlnTermination, model_data[:find_by_model_aln_termination_depth_1])
  end

  it "should find all supported matching specified condition for aln_resource descendant models" do
    mods = @root.find_in_support_hierarchy_by_model(AlnTermination, :all, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_2]['resource_name']}'") 
    verify_hierarchy_metadata(mods, AlnTermination, model_data[:find_by_model_with_condition_aln_termination_depth_1])
  end

end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 0", :shared => true  do

  it "should return nil when quried for first aln_resource model" do
    mod = @root.find_in_support_hierarchy_by_model(AlnResource, :first) 
    mod.should be_nil
  end

  it "should return empty array when queried for all aln_resource models" do 
    mods = @root.find_in_support_hierarchy_by_model(AlnResource, :all)
    mods.should be_empty
  end

  it "should return nil when quried for first aln_resource descendant model" do
    mod = @root.find_in_support_hierarchy_by_model(AlnTermination, :first) 
    mod.should be_nil
  end

  it "should return empty array when queried for all aln_resource descendant models" do 
    mods = @root.find_in_support_hierarchy_by_model(AlnTermination, :all)
    mods.should be_empty
  end

end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1 for aln_resource root"  do
  
  include FindHierarchyHelper
  
  before(:each) do
    root = AlnResource.new(model_data[:aln_resource])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported(true).first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported(true).last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported(true).first.supported(true).last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported(true).last.supported(true).last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end
  
  after(:each) do
    @root.destroy
  end

  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1 for aln_termination root"  do

  include FindHierarchyHelper

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]    
    @root.supported(true).first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    @root.supported(true).last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    @root.supported(true).first.supported(true).last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    @root.supported(true).last.supported(true).last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)

  end

  after(:each) do
    @root.destroy
  end

  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1"
  
end

#########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 1 for aln_resource root"  do

  include FindHierarchyHelper
  
  before(:all) do
    root = AlnResource.new(model_data[:aln_resource])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end
  
  after(:all) do
    @root.destroy
  end

  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 1"
  
end

###########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 1 for aln_resource descendant root"  do

  include FindHierarchyHelper

  before(:all) do
    root = AlnTermination.new(model_data[:aln_termination])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:all) do
    @root.destroy
  end

  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 1"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 0 for aln_resource root"  do
  
  before(:all) do
    root = AlnResource.new(model_data[:aln_resource])
    root.save
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end
  
  after(:all) do
    @root.destroy
  end

  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 0"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 0 for aln_termination root"  do

  before(:all) do
    root = AlnTermination.new(model_data[:aln_termination])
    root.save
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:all) do
    @root.destroy
  end

  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 0"
  
end
