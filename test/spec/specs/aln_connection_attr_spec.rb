require File.dirname(__FILE__) + '/../spec_helper'

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


