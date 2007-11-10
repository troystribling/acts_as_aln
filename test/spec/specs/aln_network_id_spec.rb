require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "assignement of network ID for two terminations that are not involved in a connection or other support relations when a support relationship is established", :shared => true do

  it "should be aln_termination_id of supporter when supporter does not have a network ID" do 
  end

  it "should be network ID of supporter when supporter has a network ID" do 
  end

end

#########################################################################################################
describe "assignement of network ID for two terminations that are not involved in a connection but are in other support relations when a support relationship is established", :shared => true do

  it "should be network ID of supporter when supported is not in a prior support relationship" do 
  end

  it "should be network ID of supporter when supported is a prior support relationship" do 
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when added to a connection that are not involved in other connections", :shared => true do

  it "should be aln_termination_id of termination if termination does not have network id and no other terminations are in connection" do 
  end

  it "should be network id of termination if termination has network id and no other terminations are in connection" do 
  end

  it "should be network id of first termination in connection" do 
  end

end

#########################################################################################################
describe "assignement of network ID for two terminations when a support relationship is established if one termination is in a connection", :shared => true do

  it "should be network ID of supporter when supporter is in a connection" do 
  end

  it "should be network ID of supported when supported is in a connection" do 
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when added to a connection if one termination in involved in a connection", :shared => true do

  it "should be aln_termination_id of termination if termination does not have network id and no other terminations are in connection" do 
  end

  it "should be network id of termination if termination has network id and no other terminations are in connection" do 
  end

  it "should be network id of first termination in connection" do 
  end

end
