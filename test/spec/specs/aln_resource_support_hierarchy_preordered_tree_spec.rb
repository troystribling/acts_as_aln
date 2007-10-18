require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
describe "initial values of preordered tree metadata for models with no supported or supporter", :shared => true do

  it "should be 1 for support_hierarchy_left" do
    @mod.support_hierarchy_left.should eql(1) 
  end

  it "should be 2 for support_hierarchy_right" do 
    @mod.support_hierarchy_right.should eql(2) 
  end

  it "should be nil for support_hierarchy_root_id" do 
    @mod.support_hierarchy_root_id.should be_nil 
  end

  it "should be nil for supporter_id" do 
    @mod.supporter_id.should be_nil 
  end

end

##########################################################################################################
describe "initial values of preordered tree metadata for aln_resource with no supported or supporter" do

  before(:each) do
    @mod = AlnResource.new
  end
  
  after(:each) do
  end
  
  it_should_behave_like "initial values of preordered tree metadata for aln_resource with no supported or supporter"
  
end

##########################################################################################################
describe "initial values of preordered tree metadata for aln_resource descendants with no supported or supporter" do

  before(:each) do
    @mod = AlnTermination.new
  end
  
  after(:each) do
  end
  
  it_should_behave_like "initial values of preordered tree metadata for aln_resource with no supported or supporter"
  
end

##########################################################################################################
describe "updates to preordered tree meta data when a supported with no supported is added to a support hierarchy", :shared => true do

  it "should update root of hiearchy and self when hierachy originally only contains root" do
    @root.support_hierarchy_root.should be_nil  
    @root.supporter_id.should be_nil  
    @root.support_hierarchy_left.should eql(1)  
    @root.support_hierarchy_right.should eql(2)  
    @root.should persist   
    @new_supported.should_not persist   
    @root << @new_supported
    @root.support_hierarchy_left.should eql(1)  
    @root.support_hierarchy_right.should eql(4)  
    @new_supported.should persist   
    @new_supported.support_hierarchy_left.should eql(2)  
    @new_supported.support_hierarchy_right.should eql(3)  
    @new_supported.support_hierarchy_root.should eql(@root_id) 
    @new_supported.supporter_id.should eql(@root_id) 
  end

end

##########################################################################################################
describe "updates to preordered tree meta data when an aln_resource with no supported is added to a support hierarchy with aln_resource root" do

  before(:each) do
    @new_supported = AlnResource.new
    @root = AlnResource.new
    @root.save
    @root_id = @root.id
  end
  
  after(:each) do
    @root.destroy
  end
  
  it_should_behave_like "updates to preordered tree meta data when a supported with no supported is added to a support hierarchy"
  
end

##########################################################################################################
describe "updates to preordered tree meta data when an aln_resource descendant with no supported is added to a support hierarchy" do

  before(:each) do
    @new_supported = AlnTermination.new
    @root = AlnTermination.new
    @root_id = @root.aln_resource.id
    @root.save
  end
  
  after(:each) do
    @root.destroy
  end
  
  it_should_behave_like "updates to preordered tree meta data when a supported with no supported is added to a support hierarchy"
  
end

