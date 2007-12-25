##############################################################################################
#### specify additional methods to be added to descriptions
module PlanB
  module SpecExtensions

    class ModelData      
      cattr_accessor :model_data  
    end
    
    def model_data
      ModelData.model_data
    end  
    
  end
end

