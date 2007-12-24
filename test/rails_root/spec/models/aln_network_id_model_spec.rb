require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "aln_network_id model network_id attribute" do

  it "should increment by one on successive retrievals" do 
    first_val = AlnNetworkId.get_network_id
    second_val = AlnNetworkId.get_network_id
    (second_val - first_val).should eql(1)
  end

end
