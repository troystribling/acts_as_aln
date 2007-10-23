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
  
  it_should_behave_like "initial values of preordered tree metadata for models with no supported or supporter"
  
end

##########################################################################################################
describe "initial values of preordered tree metadata for aln_resource descendants with no supported or supporter" do

  before(:each) do
    @mod = AlnTermination.new
  end
  
  after(:each) do
  end
  
  it_should_behave_like "initial values of preordered tree metadata for models with no supported or supporter"
  
end

##########################################################################################################
describe "incrementing preordered tree meta data by adding a supported with no supported to a support hierarchy", :shared => true do

  def add_first_supported 
    @root = @test_class.new
    @root.save
    @new_supported_1 = @test_class.new
    @root.support_hierarchy_root_id.should be_nil  
    @root.supporter_id.should be_nil  
    @root.support_hierarchy_left.should eql(1)  
    @root.support_hierarchy_right.should eql(2)  
    @root.should persist   
    @new_supported_1.should_not persist       
    @root << @new_supported_1
  end
  
  def add_second_supported
    @new_supported_2 = @test_class.new
    @new_supported_2.should_not persist   
    @root << @new_supported_2
  end

  it "should update root of hiearchy and self when hierachy originally contains only root as supported is added to root" do

    add_first_supported

    @root = AlnResource.get_as_aln_resource(@root)
    @root = AlnResource.find(@root.id)
    @new_supported_1 = AlnResource.get_as_aln_resource(@new_supported_1)
    @new_supported_1 = AlnResource.find(@new_supported_1.id)

    @root.support_hierarchy_left.should eql(1)  
    @root.support_hierarchy_right.should eql(4)  
    @new_supported_1.support_hierarchy_left.should eql(2)  
    @new_supported_1.support_hierarchy_right.should eql(3)  
    @new_supported_1.support_hierarchy_root_id.should eql(@root.id) 
    @new_supported_1.supporter_id.should eql(@root.id) 
    
    @root.to_descendant.destroy
    
  end

  it "should update root of hiearchy, self and other supported when hierachy originally contains a root with supported 1 level deep as supported is added to root" do

    add_first_supported
    add_second_supported

    @root = AlnResource.get_as_aln_resource(@root)
    @root = AlnResource.find(@root.id)
    @new_supported_1 = AlnResource.get_as_aln_resource(@new_supported_1)
    @new_supported_1 = AlnResource.find(@new_supported_1.id)

    @root.support_hierarchy_left.should eql(1)  
    @root.support_hierarchy_right.should eql(6)  
    @new_supported_1.support_hierarchy_left.should eql(4)  
    @new_supported_1.support_hierarchy_right.should eql(5)  

    @new_supported_2 = AlnResource.get_as_aln_resource(@new_supported_2)
    @new_supported_2 = AlnResource.find(@new_supported_2.id)

    @new_supported_2.support_hierarchy_left.should eql(2)  
    @new_supported_2.support_hierarchy_right.should eql(3)  
    @new_supported_2.support_hierarchy_root_id.should eql(@root.id) 
    @new_supported_2.supporter_id.should eql(@root.id) 

    @root.to_descendant.destroy
    
  end

  it "should update root of hiearchy, self and other supported when hierachy originally contains a root with supported 1 level deep as supported is added to a leaf of hierarchy" do

    new_supported_3 = @test_class.new
    new_supported_3.should_not persist   

    add_first_supported
    add_second_supported
    @new_supported_2 << new_supported_3

    @root = AlnResource.get_as_aln_resource(@root)
    @root = AlnResource.find(@root.id)
    @new_supported_1 = AlnResource.get_as_aln_resource(@new_supported_1)
    @new_supported_1 = AlnResource.find(@new_supported_1.id)
    @new_supported_2 = AlnResource.get_as_aln_resource(@new_supported_2)
    @new_supported_2 = AlnResource.find(@new_supported_2.id)
        
    @root.support_hierarchy_left.should eql(1)  
    @root.support_hierarchy_right.should eql(8)  
    @new_supported_2.support_hierarchy_left.should eql(2)  
    @new_supported_2.support_hierarchy_right.should eql(5)  
    new_supported_3.support_hierarchy_left.should eql(3)  
    new_supported_3.support_hierarchy_right.should eql(4)  
    @new_supported_1.support_hierarchy_left.should eql(6)  
    @new_supported_1.support_hierarchy_right.should eql(7)  

    @root.to_descendant.destroy
    
  end


end

##########################################################################################################
describe "updates to preordered tree meta data for aln_resource supported and aln_resource support hierarchy root" do

  before(:all) do
    @test_class = AlnResource
  end
  
  it_should_behave_like "incrementing preordered tree meta data by adding a supported with no supported to a support hierarchy"
  
end

##########################################################################################################
describe "updates to preordered tree meta data for aln_resource descendant supported and aln_resource descendant support hierarchy root" do

  before(:all) do
    @test_class = AlnTermination
  end
  
  it_should_behave_like "incrementing preordered tree meta data by adding a supported with no supported to a support hierarchy"
  
end

