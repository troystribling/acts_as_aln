require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# inheritance associations
#########################################################################################################
describe "aln_resource inheritance associations" do

  it "should declare descendant association" do 
    AlnResource.new().should declare_descendant_association
  end

  it "should have no ancestor" do 
    AlnResource.new().should_not declare_ancestor_association
  end
  
end

#########################################################################################################
# supporter association creation and deletion
####################################################################@supporter_attr_val#####################################
describe "aln_resource supporting association creation and deletion" do

  it "should be able to add supported associations for aln_resource models" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_1]['name'])
    root.should have_supported_with_attribute_value(:name, model_data[:aln_resource_supported_2]['name'])
  end

  it "should be able to remove a specified supported association for aln_resource models" do 
  end

  it "should be able to remove all supported associations for aln_resource models" do 
  end

  it "should be able to add supported associations for aln_resource decsendant models" do 
  end

  it "should be able to remove a specified supported association for aln_resource descendant models" do 
  end

  it "should be able to remove all supported associations for aln_resource descendant models" do 
  end

end

