require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
#########################################################################################################
describe "supporter model and supported model lifecyle operations relative to supporter model", :shared => true do

  it "should create supported and supporter when supported is added and destroy supported when supporter is destroyed" do 
    @root.should_not persist 
    @s1.should_not persist   
    @root << @s1
    @root.should persist 
    @s1.should persist   
    @root.destroy
    @root.should_not persist 
    @s1.should_not persist   
  end

  it "should create supported and supporter when array of supported is added and destroy supported when supporter is destroyed" do 
    @root.should_not persist 
    @s1.should_not persist   
    @s2.should_not persist   
    @root << [@s1, @s2]
    @root.should persist 
    @s1.should persist   
    @s2.should persist   
    @root.destroy
    @root.should_not persist 
    @s1.should_not persist   
    @s2.should_not persist   
  end

  it "should delete a specified supported model without deleting supporter or other supported" do 
    @root << [@s1, @s2]
    @root.should persist 
    @s1.should persist   
    @s2.should persist   
    @root.destroy_supported_by_model(@s1.class, :first, :conditions => "aln_resources.name = '#{@s1.name}'")
    @root.should persist 
    @s1.should_not persist  
    @root.supported(true).should_not include(AlnResource.to_aln_resource(@s1)) 
    @root.supported.should_not be_empty 
    @s2.should persist   
    @root.destroy
  end

  it "should delete multiple specified supported models without deleting supporter or unintended supported" do 
    @root << [@s1, @s2, @s3]
    @root.should persist 
    @s1.should persist   
    @s2.should persist   
    @s3.should persist   
    @root.destroy_supported_by_model(@s1.class, :all, :conditions => "aln_resources.name = '#{@s1.name}'")
    @root.should persist 
    @s1.should_not persist   
    @s2.should_not persist   
    @root.supported(true).should_not include(AlnResource.to_aln_resource(@s1)) 
    @root.supported.should_not include(AlnResource.to_aln_resource(@s2)) 
    @root.supported.should_not be_empty 
    @s3.should persist   
    @root.destroy
  end

  it "should delete all supported models without deleting supporter" do 
    @root << [@s1, @s2, @s3]
    @root.should persist 
    @s1.should persist   
    @s2.should persist   
    @s3.should persist   
    @root.destroy_all_supported
    @root.should persist 
    @s1.should_not persist   
    @s2.should_not persist   
    @s3.should_not persist   
    @root.supported(true).should_not include(AlnResource.to_aln_resource(@s1)) 
    @root.supported.should_not include(AlnResource.to_aln_resource(@s2)) 
    @root.supported.should_not include(AlnResource.to_aln_resource(@s3)) 
    @root.supported.should be_empty 
    @root.destroy
  end

end

#########################################################################################################
describe "supporter model and supported model lifecyle relative to supporter model when supporter aln_resource is root" do

  before(:each) do
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s3 = AlnResource.new(model_data[:aln_resource_supported_2])
  end
  
  it_should_behave_like "supporter model and supported model lifecyle operations relative to supporter model"
  
end

#########################################################################################################
describe "supporter model and supported model lifecyle relative to supporter model supporter when aln_resource descendant is root" do

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s3 = AlnTermination.new(model_data[:aln_termination_supported_2])
  end
  
  it_should_behave_like "supporter model and supported model lifecyle operations relative to supporter model"

end

##########################################################################################################
##########################################################################################################
describe "supporter model and supported model lifecyle operations relative to supported", :shared => true do

  it "should not destroy supporter when supported is destroyed" do 
   @s1.should persist
   @root.should persist
   @s1.destroy
   @s1.should_not persist
   @root.should persist
   @root.destroy
  end

end

##########################################################################################################
describe "supporter model and supported model lifecyle operations relative to aln_resource supported" do

  before(:each) do
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @root << @s1
  end

  it_should_behave_like "supporter model and supported model lifecyle operations relative to supported"

end

##########################################################################################################
describe "supporter model and supported model lifecyle operations relative to aln_resource descendent supported" do

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @root << @s1
  end

  it_should_behave_like "supporter model and supported model lifecyle operations relative to supported"

end

#########################################################################################################
describe "support hierarchy destroy operations when hierarchy depth is greater than 1", :shared => true do

  def build_hierarchy
    @root << [@s1, @s2]
    @s1   << [@s11, @s12]
    @s11  << [@s111, @s112]
    @s2   << @s21
  end
  
  def verify_persistence
    @root.should persist
    @s1.should persist
    @s2.should persist
    @s11.should persist
    @s12.should persist
    @s111.should persist
    @s112.should persist
    @s21.should persist
  end

  def verify_nonpersistence
    @s1.should_not persist
    @s2.should_not persist
    @s11.should_not persist
    @s12.should_not persist
    @s111.should_not persist
    @s112.should_not persist
    @s21.should_not persist
  end

  it "should destroy entire hierarchy and root from hierarchy root" do
    build_hierarchy
    verify_persistence
    @root.destroy
    @root.should_not persist
    verify_nonpersistence
  end

  it "should destroy entire hierarchy and root from hierarchy root for destroy method that updates support hierarchy metadata" do
    build_hierarchy
    verify_persistence
    @root.destroy_support_hierarchy
    @root.should_not persist
    verify_nonpersistence
  end

  it "should destroy entire hierarchy but not root from hierarchy root" do
    build_hierarchy
    verify_persistence
    @root.destroy_all_supported
    @root.should persist
    verify_nonpersistence
    @root.destroy
  end
    
end

#########################################################################################################
describe "support hierarchy lifecycle operations for aln_resource root when hierarchy depth is greater than 1" do

  before(:each) do
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s2 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s11 = AlnResource.new(model_data[:aln_resource_supported_2])
    @s12 = AlnResource.new(model_data[:aln_resource_supported_2])
    @s111 = AlnResource.new(model_data[:aln_resource_supported_2])
    @s112 = AlnResource.new(model_data[:aln_resource_supported_2])
    @s21 = AlnResource.new(model_data[:aln_resource_supported_2])
  end

  it_should_behave_like "support hierarchy destroy operations when hierarchy depth is greater than 1"

end

#########################################################################################################
describe "support hierarchy lifecycle operations for aln_resource descendant root when hierarchy depth is greater than 1" do

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s2 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s11 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s12 = AlnTermination.new(model_data[:aln_termination_supported_2])
    @s111 = AlnTermination.new(model_data[:aln_termination_supported_2])
    @s112 = AlnTermination.new(model_data[:aln_termination_supported_2])
    @s21 = AlnTermination.new(model_data[:aln_termination_supported_2])
  end

  it_should_behave_like "support hierarchy destroy operations when hierarchy depth is greater than 1"

end

