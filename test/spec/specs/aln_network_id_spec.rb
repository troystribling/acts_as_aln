require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "assignement of network ID for two terminations when a support relationship is established where the terminations are not involved in a connection or other support relations", :shared => true do

  it "should be nil for supporter prior to establishment of support relationship" do 
  end

  it "should be nil for supported prior to establishment of support relationship" do 
  end

  it "should be aln_termination_id of supporter after support relationship is established" do 
  end

end

#########################################################################################################
describe "assignement of network ID for two terminations when a support relationship is established where the terminations are not involved in a connection but either or both may be in other prior support relations", :shared => true do

  it "should be aln_termination_id of supporter when supported is not in a prior support relationship and supporter is in a prior supporting relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior support relationship and supported is not in a prior support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior support relationship and supported is in a prior support relationship" do 
  end

end

#########################################################################################################
describe "assignement of network ID for two terminations when a support relationship is established if either or both terminations are in a connection but neither are in other prior support relations", :shared => true do

  it "should be aln_termination_id of supporter when supporter is not in a prior connection and supported is in a prior connection" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and supported is not in a prior connection" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and supported is in a prior connection" do 
  end

end

#########################################################################################################
describe "assignement of network ID for two terminations when a support relationship is established if either or both terminations are in a connection and either are in other prior support relations", :shared => true do

  it "should be aln_termination_id of supporter when supporter is not in a prior connection or support relationship and supported is in a prior connection and support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and not in a support relationship and supported is in a prior connection and support relationship" do 
  end

  it "should be network ID of supporter when supporter is not in a prior connection and is in a support relationship and supported is in a prior connection and support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is not in a prior connection or support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is not in a prior connection but is in a prior support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is in a prior connection but is not in a prior support relationship" do 
  end

  it "should be network ID of supporter when supporter is in a prior connection and support relationship and supported is in a prior connection and support relationship" do 
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when added to a connection where the terminations are not involved in other prior connections or other prior support relations", :shared => true do

  it "should be nil for supporter prior to establishment of connection" do 
  end

  it "should be nil for supported prior to establishment of connection" do 
  end

  it "should be aln_termination_id of termination added to connection if no other terminations are in connection" do 
  end

  it "should be network ID of termination in connection as termination is added to connection" do 
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when added to a connection if either or both terminations are involved in a connection but not in other prior support relations", :shared => true do

  it "should be network ID of termination in connection as termination with connection is added to connection" do 
  end

end

#########################################################################################################
describe "assignement of network ID for terminations when added to a connection if either termination is involved in a connection and either are in other prior support relations", :shared => true do

  it "should be network ID of termination in connection as termination with connection and supported is added to connection" do 
  end

end
