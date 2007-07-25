require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
# attributes
#########################################################################################################
describe "attributes supported by aln_termination" do

  before(:all) do
    @t = AlnTermination.new()
  end

  it "should have directionality attribute that can only have vaules unidirectional and bidirectional" do 
    @t.directionality = 'unidirectional'
    p @t
    @t.save.should be_true
    @t.directionality = 'bidirectional'
    @t.save.should be_true
    @t.directionality = 'invalid_value'
    @t.save.should be_false
    @t.destroy
  end

  it "should have direction attribute that can only have vaules client, server and peer" do 
    @t.direction = 'client'
    @t.save.should be_true
    @t.direction = 'server'
    @t.save.should be_true
    @t.direction = 'peer'
    @t.save.should be_true
    @t.direction = 'invalid_value'
    @t.save.should be_false
    @t.destroy
 end

end

#########################################################################################################
# inheritance relations
#########################################################################################################
describe "aln_termination inheritance associations" do

  before(:all) do
    @t = AlnTermination.new()
  end

  it "should be able to have descendants" do 
    @t.should respond_to(:get_descendant)
  end

  it "should have aln_resource as ancestor" do 
    @t.should be_descendant_of(:aln_resource)
  end

end

#########################################################################################################
# connection associations
#########################################################################################################
describe "aln_termination connection associations" do

  before(:all) do
    @t = AlnTermination.new()
    @t.save
  end

  after(:all) do
    @t.destroy
  end 

  it "should be able to be in a connection" do 
    @t.should respond_to(:aln_connection_id)
  end

end

