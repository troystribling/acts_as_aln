require File.dirname(__FILE__) + '/../spec_helper'

##########################################################################################################
module NetworkIdHelper

  def check_layer_id(model, id, layer_id)
    chk = model.find(id)
    chk.layer_id.should eql(layer_id)
  end
  
end

#########################################################################################################
describe "assignement of layer ID for a termination when a support relationship is established with a nonterminating aln_resource where the termination is not involved in a connection or other support relations" do

  it "should be 0 for termination prior to establishment of support relationship" do 
  end

  it "should be 0 for termination after to establishment of support relationship" do 
  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a support relationship is established where the terminations are not involved in a connection or other support relations with terminations" do

  it "should increase from 0 to 1 when first supported is added" do 
  end

  it "should remain 1 when other supported are aded" do 
  end

  it "should remain 1 when other supported are aded to another termination with the same layer ID" do 
  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a support relationship is established where the terminations are not involved in a connection but are involved support relations with terminations" do

  it "should increase from 0 to 2 when first supported is added if it has a single layer of supported" do 
  end

  it "should remain 2 when other supported are addd with only a single layer of supported" do 
  end

  it "should remain 2 when other supported are added with only a single layer of supported to another termination with the same layer ID" do 
  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a connection is established where the terminations are not involved in a connection and are not involved support relations with terminations" do

  it "should be 0 for termination prior to establishment of connection" do 
  end

  it "should be 0 for termination after to establishment of connection" do 
  end

  it "should be 0 after establishment of connection with another termination" do 
  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a connection is established where the terminations are not involved in a connection but are involved support relations with terminations" do

  it "should be 1 for network when connection is established when connected termination has layer ID of 1 and the connecting termination has layer ID of 0" do 
  end

  it "should be 1 for network when connection is established when connected termination has layer ID of 1 and the connecting termination has layer ID of 1" do 
  end

  it "should be 1 for network when connection is established when connected termination has layer ID of 0 and the connecting termination has layer ID of 1" do 
  end

end

#########################################################################################################
describe "assignement of layer ID for terminations when a connection is established at a supporting layer where terminations are involved in a connection and are involved a support relation with other terminations which are also involved in support relations", :shared => true do

  it "should be 2 for network when connection is established when connected termination has layer ID of 2 and the connecting termination has layer ID of 1" do 
  end

  it "should be 2 for network when connection is established when connected termination has layer ID of 2 and the connecting termination has layer ID of 2" do 
  end

  it "should be 2 for network when connection is established when connected termination has layer ID of 1 and the connecting termination has layer ID of 2" do 
  end

end
