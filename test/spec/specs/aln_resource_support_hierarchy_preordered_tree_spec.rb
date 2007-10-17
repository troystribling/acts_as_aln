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
describe "updates to preordered tree meta data when a node with no supported is added to a support hierarchy", :shared => true do

  it "should update root of hiearchy and self when hierachy only contains root" do 
  end

end

##########################################################################################################
describe "updates to preordered tree meta data when an aln_resource with no supported is added to a support hierarchy" do

  before(:each) do
    @node = AlnResource.new
  end
  
  after(:each) do
  end
  
  it_should_behave_like "updates to preordered tree meta data when a node with no supported is added to a support hierarchy"
  
end

##########################################################################################################
describe "updates to preordered tree meta data when an aln_resource descendant with no supported is added to a support hierarchy" do

  before(:each) do
    @node = AlnTermination.new
  end
  
  after(:each) do
  end
  
  it_should_behave_like "updates to preordered tree meta data when a node with no supported is added to a support hierarchy"
  
end

