############################################################
# match attributes of model against hash of expected values
module PlanB
  module SpecMatchers    

      class BeImplemented  #:nodoc:
    
        def matches?(exp)
          false
        end
        
        def failure_message
          'Example not implemented'
        end
  
        def negative_failure_message
          'Take it out then'
        end

        def description
          "implemented it"
        end
  
      end
    
      def be_implemented
        BeImplemented.new
      end
   
  end
end