############################################################
# match attributes of model against hash of expected values
module PlanB
  module SpecMatchers    

      class HaveAttributesWithValues  #:nodoc:
    
        def initialize(expected)
          @expected = expected
        end
    
        def matches?(mod)  
          if mod.class.eql?(Array)
            result = mod.find do |m|
              check_model(m) == false
            end
            result.nil? ? true : false
          else
            check_model(mod)
          end
        end
        
        def check_model(mod)
          @attr = mod.attributes
          result = @expected.find do |key, val|
            val != @attr[key]
          end
          result.nil? ? true : false
        end
        
        def failure_message
          error_msg = "Attribute match error\n"
          @expected.each do |key, val|
             error_msg << " attribute value '#{@attr[key]}' for '#{key}' expecting '#{val}'\n" 
          end
          error_msg
        end
  
        def description
          "check model attribute values"
        end
  
      end
    
      def have_attributes_with_values(expected)
        HaveAttributesWithValues.new(expected)
      end
   
  end
end