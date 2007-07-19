require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# attributes
#########################################################################################################
describe "attributes supported by aln_resources" do

  before(:all) do
    @r = AlnResource.new()
    @r.save
  end

  it "should identify date and time of object creation" do 
    @r.created_at.class.should eql(Time)
  end

  it "should identify date and time of last object update" do 
    @r.updated_at.class.should eql(Time)
  end
  
  it "should identify name of resource as string" do 
    @r.name.class.should eql(String)
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
    @r.should respond_to(:get_descendant)
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
    @r = AlnResource.new()
    @r.save
  end

  it "should have a supporter" do 
    @r.should respond_to(:supporter)
  end

  it "should have many supported" do 
    @r.should respond_to(:supported)
  end

  it "should be able to specfy supported type as astring" do 
    @r.supported_type.class.should eql(String)
  end

end
