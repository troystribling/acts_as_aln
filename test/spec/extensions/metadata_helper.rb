module PlanB
  module SpecExtensions

    def check_layer_id(model, id, layer_id)
      chk = model.find(id)
      chk.layer_id.should eql(layer_id)
    end

    def check_network_id(model, id, network_id)
      chk = model.find(id)
      chk.network_id.should eql(network_id)
    end

    def check_termination_supporter_id(model, id, supporter_id)
      chk = model.find(id)
      chk.termination_supporter_id.should eql(supporter_id)
    end

  end
end