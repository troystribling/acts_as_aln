require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should declare descendant association" do 
    AlnConnection.new().should declare_descendant_association
  end

  it "should have aln_resource ancestor association" do 
    AlnConnection.new().should be_descendant_of(AlnResource)
  end

end

#########################################################################################################
describe "aln_connection termination associations" do

  it "should have many terminations" do 
    AlnConnection.new().should respond_to(:aln_terminations)
  end

end

#########################################################################################################
describe "aln_connection directionality attribute" do

  it "should be valid for value nil" do 
    AlnConnection.new().should be_valid
  end

  it "should be valid for value unidirectional" do 
    AlnConnection.new(:directionality => 'unidirectional').should be_valid
  end

  it "should be valid for value bidirectional" do 
    AlnConnection.new(:directionality => 'bidirectional').should be_valid
  end

  it "should be inavlid for value different from nil, unidirectional or bidirectional" do 
    AlnConnection.new(:directionality => 'invalid_value').should_not be_valid
  end

end


