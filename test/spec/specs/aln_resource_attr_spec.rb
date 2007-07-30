require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# timeof model create and update
#########################################################################################################
describe "attributes indentifying model update time and create time" do

  before(:all) do
    @r = AlnResource.new(:name => model_data[:aln_resource][:name])
    @r.save
  end

  after(:all) do
    @r.destroy
  end 
  
  it "should identify date and time of model creation in database with created_at attribute" do 
    @r.created_at.class.should eql(Time)
  end

  it "should identify date and time of last object update in databasenwith updated_at attribute" do 
    @r.updated_at.class.should eql(Time)
  end
    
end

#########################################################################################################
# 
#########################################################################################################
describe "attributes identifying an aln_resource" do

  before(:all) do
    @r = AlnResource.new(:name => model_data[:aln_resource][:name])
  end

  it "should identify name of aln_resource as string" do 
    @r.name.should eql(model_data[:aln_resource][:name])
  end
  
end
