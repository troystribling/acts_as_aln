##############################################################################################
#### specify model_data global configuration object
class Spec::DSL::Configuration
  attr_accessor :model_data  
end

##############################################################################################
#### specify additional methods to be added to descriptions
module PlanB
  module SpecExtensions
    def model_data
      Spec::Runner.configuration.model_data
    end  
  end
end

