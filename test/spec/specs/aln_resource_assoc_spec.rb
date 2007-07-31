require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# inheritance associations
#########################################################################################################
describe "aln_resource inheritance associations" do

  before(:all) do
    @r = AlnResource.new()
  end

  it "should declare descendant association" do 
    @r.should declare_descendant_association
  end

  it "should have no ancestor" do 
    @r.ancestor.should be_nil
  end
  
end

#########################################################################################################
# supporter associations
#########################################################################################################
describe "aln_resource supporter associations" do

  before(:all) do
    @r = AlnResource.new(:supported_type => model_data[:aln_resource][:supported_type])
    @r.save
  end

  after(:all) do
    @r.destroy
  end 

  it "should have a supporter associations" do 
    @r.should respond_to(:supporter)
  end

  it "should have many supported" do 
    @r.should respond_to(:supported)
  end

  it "should be able to specfy supported type as astring" do 
    @r.supported_type.should eql(model_data[:aln_resource][:supported_type])
  end

end

