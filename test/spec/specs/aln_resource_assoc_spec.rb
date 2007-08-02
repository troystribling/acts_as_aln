require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# inheritance associations
#########################################################################################################
describe "aln_resource inheritance associations" do

  it "should declare descendant association" do 
    AlnResource.new().should declare_descendant_association
  end

  it "should have no ancestor" do 
    AlnResource.new().ancestor.should be_nil
  end
  
end

#########################################################################################################
# supporter associations
#########################################################################################################
describe "aln_resource supporter associations" do

  before(:all) do
    @root = AlnResource.new(:name => model_data[:aln_resource][:name])
  end

  it "should be able to add and iterate through multiple supporter aln_resource associations" do 
    @root << AlnResource.new(:name => model_data[:aln_resource_supporter_1][:name])
    @root << AlnResource.new(:name => model_data[:aln_resource_supporter_2][:name])
    @root.supporter.each_with_index do |s, i|
      p s,i
    end
  end

  it "should be able to remove a supporter aln_resource associations" do 
  end

  it "should be able to remove all supporter aln_resource associations" do 
  end

  it "should be able to add athrough nd interate multiple supporter aln_resource descendant associations" do 
    @root << AlnTermination.new(:name => model_data[:aln_termination_supporter_1][:name])
    @root << AlnTermination.new(:name => model_data[:aln_termination_supporter_2][:name])
  end

  it "should be able to remove a supporter aln_resource descendant associations" do 
  end

  it "should be able to remove all supporter aln_resource descendant associations" do 
  end

end

