require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# attributes
#########################################################################################################
describe "attributes supported by aln_resources" do

  before(:all) do
    @r = AlnResource.new()
  end

  it "should identify date and time of object creation" do 
    @r.created_at.class.should eql('DateTime')
  end

  it "should identify date and time of last object update" do 
    @r.updated_at.class.should eql('DateTime')
  end
  
  it "should identify name of resource as string" do 
    @r.name.class.should eql('String')
  end
  
end

#########################################################################################################
# inheritance associations
#########################################################################################################
describe "aln_resource inheritance associations" do

  before(:all) do
    @r = AlnResource.new()
  end

  it "should be able to have descendants" do 
    @r.should respond_to(:descendant)
  end

  it "should have no ancestor" do 
    @r.ancestor.should be_nil
  end
  
end

#########################################################################################################
# supporter associations
#########################################################################################################
describe "aln_resource supporter associations" do

  it "should have a supporter" do 
  end

  it "should have many supported" do 
  end

  it "should be able to specfy supported type" do 
    @r.should respond_to(:supported_type)
  end

end
