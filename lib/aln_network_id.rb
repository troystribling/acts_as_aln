class AlnNetworkId < ActiveRecord::Base

  ####################################################################################
  # class methods
  class << self
  
    def get_network_id
      net_id_mod = self.find(:first)
      net_id_mod = AlnNetworkId.new if net_id_mod.nil?
      net_id_mod.network_id += 1
      net_id_mod.save
      net_id_mod.network_id 
    end
    
  end

end