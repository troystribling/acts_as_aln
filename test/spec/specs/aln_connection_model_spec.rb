require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_connection inheritance associations" do

  it "should declare descendant association" do 
    AlnConnection.should declare_descendant_association
  end

  it "should have aln_resource ancestor association" do 
    AlnConnection.should be_descendant_of(AlnResource)
  end

end

#########################################################################################################
describe "aln_connection termination associations" do

  it "should have many terminations" do 
    AlnConnection.new.should have_method(:aln_terminations)
  end

end

##########################################################################################################
describe "attributes supported by aln_connection models" do

  it "should include network identifier" do 
    AlnConnection.should have_attribute(:network_id, :integer)
  end

  it "should include layer identifier" do 
    AlnConnection.should have_attribute(:layer_id, :integer)
  end

  it "should include path identifier" do 
    AlnConnection.should have_attribute(:path_id, :integer)
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


