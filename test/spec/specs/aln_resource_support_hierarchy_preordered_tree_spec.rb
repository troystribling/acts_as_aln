require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
module PreorderedTreeHierarchyHelper

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
    root_chk = AlnResource.to_aln_resource(root)
    root_chk = AlnResource.find(root_chk.id)
    root_chk.support_hierarchy_left.should eql(left)  
    root_chk.support_hierarchy_right.should eql(right) 
    root_chk 
  end

  def verify_supported(hierachy_root, root, sup, left, right)
    sub_chk = verify_root(sup, left, right)
    root_chk = AlnResource.to_aln_resource(root)
    hierachy_root_chk = AlnResource.to_aln_resource(hierachy_root)
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
describe "update of preordered tree meta data by adding a supported with no supported to a support hierarchy", :shared => true do

  it "should modify root of hiearchy if hierachy contains only root" do

    #### build hierarchy
    add_first_supported(@root, @s1)

    #### verify hierachy meta data
    verify_root(@root, 1, 4)
    verify_supported(@root, @root, @s1, 2, 3)

    #### clean up
    @root.destroy

  end

  it "should modify root of hiearchy and other supported if hierachy contains a root with supported 1 level deep when adding supporting does not increase hierachy depth" do

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

  it "should modify root of hiearchy and other supported if hierachy contains a root with supported 1 level deep when adding supporting increases hierachy depth" do

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

  it "should modify only specified hierarchy when hierarchies with multiple roots are contained in database" do

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
describe "update of preordered tree meta data when adding a supported that is a support hierarchy root", :shared => true do

  it "should modify target hierarchy root and added support hierachy if target hierarchy consists only of a root" do

    #### build added hierarchy
    add_first_supported(@root2, @s21)
    add_supported(@root2, @s22)
    add_supported(@root2, @s23)

    #### verify added hierarchy
    verify_root(@root2, 1, 8)
    verify_supported(@root2, @root2, @s21, 6, 7)
    verify_supported(@root2, @root2, @s22, 4, 5)
    verify_supported(@root2, @root2, @s23, 2, 3)

    #### verify root
    @root.save
    verify_root(@root, 1, 2)
    
    #### add subtree to root
    @root.add_support_hierarchy(@root2)
    
    #### verify metadata update    
    verify_root(@root, 1, 10)
    verify_supported(@root, @root, @root2, 2, 9)
    verify_supported(@root, @root2, @s21, 7, 8)
    verify_supported(@root, @root2, @s22, 5, 6)
    verify_supported(@root, @root2, @s23, 3, 4)
    
    #### clean up
    @root.destroy
    @root2.destroy
    
  end

  it "should modify target hierarchy and added support hierachy if target hierarchy consists of root with supported" do

    #### build added hierarchy
    add_first_supported(@root2, @s21)
    add_supported(@root2, @s22)
    add_supported(@root2, @s23)

    #### verify added hierarchy
    verify_root(@root2, 1, 8)
    verify_supported(@root2, @root2, @s21, 6, 7)
    verify_supported(@root2, @root2, @s22, 4, 5)
    verify_supported(@root2, @root2, @s23, 2, 3)

    #### build target hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@root, @s3)

    #### verify target hierarchy
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 4, 5)
    verify_supported(@root, @root, @s3, 2, 3)
    
    #### add subtree to root
    @s3.add_support_hierarchy(@root2)
    
    #### verify metadata update    
    verify_root(@root, 1, 16)
    verify_supported(@root, @root, @s1, 14, 15)
    verify_supported(@root, @root, @s2, 12, 13)
    verify_supported(@root, @root, @s3, 2, 11)
    verify_supported(@root, @s3, @root2, 3, 10)
    verify_supported(@root, @root2, @s21, 8, 9)
    verify_supported(@root, @root2, @s22, 6, 7)
    verify_supported(@root, @root2, @s23, 4, 5)
    
    #### clean up
    @root.destroy
    @root2.destroy
    
  end

  it "should modify only specified hierarchy if hierarchies with different roots are contained in database" do

    #### build added hierarchy
    add_first_supported(@root2, @s21)
    add_supported(@root2, @s22)
    add_supported(@root2, @s23)

    #### verify added hierarchy
    verify_root(@root2, 1, 8)
    verify_supported(@root2, @root2, @s21, 6, 7)
    verify_supported(@root2, @root2, @s22, 4, 5)
    verify_supported(@root2, @root2, @s23, 2, 3)

    #### build target hierarchy
    add_first_supported(@root, @s1)
    add_supported(@root, @s2)
    add_supported(@root, @s3)

    #### verify target hierarchy
    verify_root(@root, 1, 8)
    verify_supported(@root, @root, @s1, 6, 7)
    verify_supported(@root, @root, @s2, 4, 5)
    verify_supported(@root, @root, @s3, 2, 3)

    #### build control hierarchy
    add_first_supported(@root3, @s31)
    add_supported(@root3, @s32)
    add_supported(@root3, @s33)

    #### verify control hierarchy
    verify_root(@root3, 1, 8)
    verify_supported(@root3, @root3, @s31, 6, 7)
    verify_supported(@root3, @root3, @s32, 4, 5)
    verify_supported(@root3, @root3, @s33, 2, 3)
    
    #### add subtree to root
    @s3.add_support_hierarchy(@root2)
    
    #### verify metadata update    
    verify_root(@root, 1, 16)
    verify_supported(@root, @root, @s1, 14, 15)
    verify_supported(@root, @root, @s2, 12, 13)
    verify_supported(@root, @root, @s3, 2, 11)
    verify_supported(@root, @s3, @root2, 3, 10)
    verify_supported(@root, @root2, @s21, 8, 9)
    verify_supported(@root, @root2, @s22, 6, 7)
    verify_supported(@root, @root2, @s23, 4, 5)

    #### verify control hierarchy
    verify_root(@root3, 1, 8)
    verify_supported(@root3, @root3, @s31, 6, 7)
    verify_supported(@root3, @root3, @s32, 4, 5)
    verify_supported(@root3, @root3, @s33, 2, 3)
    
    #### clean up
    @root.destroy
    @root2.destroy
    @root3.destroy

  end
  
end

##########################################################################################################
describe "update of preordered tree meta data when removing a supported that is a support hierarchy root", :shared => true do

  it "should modify target hierarchy root and removed support hierachy when target hiearchy consists only of a root" do
  end

  it "should modify target hierarchy root and removed support hierachy when target hiearchy consists of a root with supported" do
  end

end

##########################################################################################################
describe "update of preordered tree meta data for support hiearchy by destroying a supported with no supported", :shared => true do

  it "should modify meta data of hierarchy root if it originally contains only root and one supported when supported is destroyed" do

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

  it "should modify root of hiearchy and other supported if hierachy contains a root with supported 1 level deep" do

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

  it "should modify root of hiearchy and other supported if hierachy contains a root with supported 2 levels deep" do

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

  it "should modify only specified hierarchies when hierarchies with different roots are contained in database" do

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
describe "update of preordered tree meta data for all model destroy methods", :shared => true do

  it "should modify hierarchy metadata when destroy_as_supported is called" do

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

  it "should modify hierarchy metadata when destroy_all_supported is called" do

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

  it "should modify hierarchy metadata when destroy_supported_by_model with :first option is called" do

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

  it "should modify hierarchy metadata when destroy_supported_by_model with :all option is called" do

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

###########################################################################################################
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
describe "updates to preordered tree meta data for aln_resource supported and aln_resource support hierarchy root" do

  include PreorderedTreeHierarchyHelper

  before(:each) do
    
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s3 = AlnResource.new(model_data[:aln_resource_supported_2])

    @root2 = AlnResource.new(model_data[:aln_resource])
    @s21 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s22 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s23 = AlnResource.new(model_data[:aln_resource_supported_2])

    @root3 = AlnResource.new(model_data[:aln_resource])
    @s31 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s32 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s33 = AlnResource.new(model_data[:aln_resource_supported_2])

  end
  
  it_should_behave_like "update of preordered tree meta data by adding a supported with no supported to a support hierarchy"

  it_should_behave_like "update of preordered tree meta data for support hiearchy by destroying a supported with no supported"

  it_should_behave_like "update of preordered tree meta data for all model destroy methods"

  it_should_behave_like "update of preordered tree meta data when adding a supported that is a support hierarchy root"
  
end

##########################################################################################################
describe "updates to preordered tree meta data for aln_resource descendant supported and aln_resource descendant support hierarchy root" do

  include PreorderedTreeHierarchyHelper
  
  before(:each) do

    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s3 = AlnTermination.new(model_data[:aln_termination_supported_2])

    @root2 = AlnTermination.new(model_data[:aln_termination])
    @s21 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s22 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s23 = AlnTermination.new(model_data[:aln_termination_supported_2])

    @root3 = AlnTermination.new(model_data[:aln_termination])
    @s31 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s32 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s33 = AlnTermination.new(model_data[:aln_termination_supported_2])

  end
  
  it_should_behave_like "update of preordered tree meta data by adding a supported with no supported to a support hierarchy"

  it_should_behave_like "update of preordered tree meta data for support hiearchy by destroying a supported with no supported"

  it_should_behave_like "update of preordered tree meta data for all model destroy methods"

  it_should_behave_like "update of preordered tree meta data when adding a supported that is a support hierarchy root"
  
end

