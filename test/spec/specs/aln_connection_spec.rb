require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# attributes
#########################################################################################################
describe "attributes supported by aln_connection" do
end

#########################################################################################################
# inheritance relations
#########################################################################################################
describe "aln_connection inheritance associations" do

  before(:all) do
    @c = AlnTermination.new()
  end

  it "should be able to have descendants" do 
    @c.should respond_to(:get_descendant)
  end

  it "should have aln_resource as ancestor" do 
    @c.should be_descendant_of(:aln_resource)
  end

end

#########################################################################################################
# termination associations
#########################################################################################################
describe "aln_connection terminations associations" do

  before(:all) do
    @c = AlnTermination.new()
    @c.save
  end

  after(:all) do
    @c.destroy
  end 

#  it "should be able to have many terminations" do 
#    @c.should respond_to(:aln_terminations)
#  end

end

