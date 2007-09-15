##############################################################
# match attributes of model against hash of expected values
module PlanB
  
  module SpecMatchers    

      class HaveValues < PlanB::SpecMatchers::ArrayMatcher #:nodoc:
      
        def description
          "match array of values"
        end

      end
    
      def have_values(expected)
        HaveValues.new(expected)
      end
   
  end
end