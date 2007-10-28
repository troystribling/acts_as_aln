require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
module HierarchyHelper

   def add_first_supported(root, sup)
    root.save
    root.support_hierarchy_root_id.should be_nil  
    root.supporter_id.should be_nil  
    root.support_hierarchy_left.should eql(1)  
    root.support_hierarchy_right.should eql(2)  
    root.should persist   
    add_supported(root, sup)
  end

  def add_supported(root, sup)
    sup.should_not persist   
    root << sup
    sup.should persist   
  end
   
  def verify_root(root, left, right)
    root_chk = AlnResource.get_as_aln_resource(root)
    root_chk = AlnResource.find(root_chk.id)
    root_chk.support_hierarchy_left.should eql(left)  
    root_chk.support_hierarchy_right.should eql(right) 
    root_chk 
  end

  def verify_supported(hierachy_root, root, sup, left, right)
    sub_chk = verify_root(sup, left, right)
    root_chk = AlnResource.get_as_aln_resource(root)
    hierachy_root_chk = AlnResource.get_as_aln_resource(hierachy_root)
    sub_chk.support_hierarchy_root_id.should eql(hierachy_root_chk.id) 
    sub_chk.supporter_id.should eql(root_chk.id) 
  end
  
end

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

  it "should update root of hiearchy and self when hierachy originally contains only root as supported is added to root" do

    #### build hierarchy
    add_first_supported(@root, @s1)

    #### verify hierachy meta data
    verify_root(@root, 1, 4)
    verify_supported(@root, @root, @s1, 2, 3)

    #### clean up
    @root.destroy

  end

  it "should update root of hiearchy, self and other supported when hierachy originally contains a root with supported 1 level deep as supported is added to root" do

    #### build hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)

    #### verify hierachy meta data
    verify_root(@root, 1, 6)
    verify_supported(@root, @root, @s1, 4, 5)
    verify_supported(@root, @root, @s2, 2, 3)

    #### clean up
    @root.destroy
    
  end

  it "should update root of hiearchy, self and other supported when hierachy originally contains a root with supported 1 level deep as supported is added to a leaf of hierarchy" do

    #### build hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@s2, @s3)

    #### verify hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 2, 5)
    verify_supported(@root, @s2, @s3, 3, 4)

    #### clean up
    @root.destroy
    
  end

  it "should update only specified hierarchy when hierarchies with multiple roots are contained in database" do

    #### build control hiearchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@s2, @s3)

    #### verify control hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 2, 5)
    verify_supported(@root, @s2, @s3, 3, 4)

    #### build second hierarchy to be updated
    add_first_supported(@root2, @s21)
    add_supported(@root2, @s22)
    add_supported(@s22, @s23)

    #### verify updated hierarchy
    verify_root(@root2, 1, 8)
    verify_supported(@root2, @root2, @s21, 6, 7)
    verify_supported(@root2, @root2, @s22, 2, 5)
    verify_supported(@root2, @s22, @s23, 3, 4)

    ### verify that control hierachy was not modified
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 2, 5)
    verify_supported(@root, @s2, @s3, 3, 4)

    #### clean up
    @root.destroy
    @root2.destroy

  end
  
end

##########################################################################################################
describe "decrementing preordered tree meta data by destroying a supported with no supported which belongs to a support hierarchy", :shared => true do

  it "should update root of hiearchy hierachy originally contains only root and one supported when supported is destroyed" do

    #### build hierarchy
    add_first_supported(@root, @s1)

    #### verify hierachy meta data
    verify_root(@root, 1, 4)
    verify_supported(@root, @root, @s1, 2, 3)

    #### destroy supported
    @s1.destroy_as_supported

    #### validate database changes
    @root.should persist   
    @s1.should_not persist   

    #### validate changes to metadata
    verify_root(@root, 1, 2)

    #### clean up
    @root.destroy

  end

  it "should update root of hiearchy, self and other supported when hierachy originally contains a root with supported 1 level deep as supported is removed from root" do

    #### build hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)

    #### verify hierachy meta data
    verify_root(@root, 1, 6)
    verify_supported(@root, @root, @s1, 4, 5)
    verify_supported(@root, @root, @s2, 2, 3)

    #### destroy supported
    @s2.destroy_as_supported

    #### validate database changes
    @root.should persist   
    @s1.should persist   
    @s2.should_not persist   
        
    #### validate changes to metadata
    verify_root(@root, 1, 4)
    verify_supported(@root, @root, @s1, 2, 3)

    #### clean up
    @root.destroy
    
  end

  it "should update root of hiearchy, self and other supported when hierachy originally contains a root with supported 1 level deep as supported is removed from a leaf of hierarchy" do

    #### construct hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@s2, @s3)

    #### verify hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 2, 5)
    verify_supported(@root, @s2, @s3, 3, 4)

    #### destroy supported
    @s3.destroy_as_supported

    #### validate database changes
    @root.should persist   
    @s1.should persist   
    @s2.should persist   
    @s3.should_not persist   

    #### validate changes to metadata
    verify_root(@root, 1, 6)
    verify_supported(@root, @root, @s1, 4, 5)
    verify_supported(@root, @root, @s2, 2, 3)

    #### clean up
    @root.destroy

  end

  it "should update only specified hierarchy when hierarchies with multiple roots are contained in database" do

    #### build control hiearchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@s2, @s3)

    #### verify control hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 2, 5)
    verify_supported(@root, @s2, @s3, 3, 4)

    #### build second hierarchy to be updated
    add_first_supported(@root2, @s21)
    add_supported(@root2, @s22)
    add_supported(@s22, @s23)

    #### verify updated hierarchy metadata
    verify_root(@root2, 1, 8)
    verify_supported(@root2, @root2, @s21, 6, 7)
    verify_supported(@root2, @root2, @s22, 2, 5)
    verify_supported(@root2, @s22, @s23, 3, 4)

    #### destroy supported in updated hierarchy
    @s23.destroy_as_supported

    #### validate database changes
    @root.should persist   
    @s1.should persist   
    @s2.should persist   
    @s3.should persist   
    @root2.should persist   
    @s21.should persist   
    @s22.should persist   
    @s23.should_not persist   

    ### verify that control hierachy was not modified
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 2, 5)
    verify_supported(@root, @s2, @s3, 3, 4)

    #### verify meta data for updated hierarchy
    verify_root(@root2, 1, 6)
    verify_supported(@root2, @root2, @s21, 4, 5)
    verify_supported(@root2, @root2, @s22, 2, 3)

    #### clean up
    @root.destroy
    @root2.destroy

  end
  
end

##########################################################################################################
describe "decrementing preordered tree meta data for all model destroy methods", :shared => true do

  it "should update hierarchy metadata when destroy_as_supported is called" do

    #### construct hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@s2, @s3)

    #### verify hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 2, 5)
    verify_supported(@root, @s2, @s3, 3, 4)

    #### destroy
    @s3.destroy_as_supported

    #### validate database changes
    @root.should persist   
    @s1.should persist   
    @s2.should persist   
    @s3.should_not persist   

    #### validate changes to metadata
    verify_root(@root, 1, 6)
    verify_supported(@root, @root, @s1, 4, 5)
    verify_supported(@root, @root, @s2, 2, 3)

    #### clean up
    @root.destroy

  end

  it "should update hierarchy metadata when destroy_all_supported is called" do

    #### construct hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@root, @s3)

    #### verify hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 4, 5)
    verify_supported(@root, @root, @s3, 2, 3)

    #### destroy 
    @root.destroy_all_supported

    #### validate database changes
    @root.should persist   
    @s1.should_not persist   
    @s2.should_not persist   
    @s3.should_not persist   

    #### validate changes to metadata
    verify_root(@root, 1, 2)

    #### clean up
    @root.destroy

  end

  it "should update hierarchy metadata when destroy_supported_by_model with :first option is called" do

    #### construct hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@root, @s3)

    #### verify hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 4, 5)
    verify_supported(@root, @root, @s3, 2, 3)

    #### destroy
    @root.destroy_supported_by_model(@s1.class, :first, :conditions => "aln_resources.resource_name = '#{@s1.resource_name}'")

    #### validate database changes
    @root.should persist   
    @s1.should_not persist   
    @s2.should persist   
    @s3.should persist   

    #### validate changes to metadata
    verify_root(@root, 1, 6)
    verify_supported(@root, @root, @s2, 4, 5)
    verify_supported(@root, @root, @s3, 2, 3)

    #### clean up
    @root.destroy

  end

  it "should update hierarchy metadata when destroy_supported_by_model with :all option is called" do

    #### construct hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@root, @s3)

    #### verify hierachy meta data
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 4, 5)
    verify_supported(@root, @root, @s3, 2, 3)

    #### destroy
    @root.destroy_supported_by_model(@s1.class, :all, :conditions => "aln_resources.resource_name = '#{@s1.resource_name}'")

    #### validate database changes
    @root.should persist   
    @s1.should_not persist   
    @s2.should_not persist   
    @s3.should persist   

    #### validate changes to metadata
    verify_root(@root, 1, 4)
    verify_supported(@root, @root, @s3, 2, 3)

    #### clean up
    @root.destroy

  end
    
end
##########################################################################################################
describe "updates to preordered tree meta data for aln_resource supported and aln_resource support hierarchy root" do

  include HierarchyHelper

  before(:each) do
    
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s3 = AlnResource.new(model_data[:aln_resource_supported_2])

    @root2 = AlnResource.new(model_data[:aln_resource])
    @s21 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s22 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s23 = AlnResource.new(model_data[:aln_resource_supported_2])

  end
  
  it_should_behave_like "incrementing preordered tree meta data by adding a supported with no supported to a support hierarchy"

  it_should_behave_like "decrementing preordered tree meta data by destroying a supported with no supported which belongs to a support hierarchy"

  it_should_behave_like "decrementing preordered tree meta data for all model destroy methods"
  
end

##########################################################################################################
describe "updates to preordered tree meta data for aln_resource descendant supported and aln_resource descendant support hierarchy root" do

  include HierarchyHelper
  
  before(:each) do

    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s3 = AlnTermination.new(model_data[:aln_termination_supported_2])

    @root2 = AlnTermination.new(model_data[:aln_termination])
    @s21 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s22 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s23 = AlnTermination.new(model_data[:aln_termination_supported_2])

  end
  
  it_should_behave_like "incrementing preordered tree meta data by adding a supported with no supported to a support hierarchy"

  it_should_behave_like "decrementing preordered tree meta data by destroying a supported with no supported which belongs to a support hierarchy"

  it_should_behave_like "decrementing preordered tree meta data for all model destroy methods"
  
end

