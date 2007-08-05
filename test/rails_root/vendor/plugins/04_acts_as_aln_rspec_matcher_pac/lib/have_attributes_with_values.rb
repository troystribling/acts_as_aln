############################################################
# match attributes of model against hash of expected values
module PlanB
  module SpecMatchers    

      class HaveAttributesWithValues  #:nodoc:
    
        def initialize(expected)
          @expected = expected
        end
    
        def matches?(mod)
          @attr = mod.attributes
          if @attr.class.eql?(Hash)
            result = @expected.find do |key, val|
              val != @attr[key]
            end
            result.nil? ? true : false
          else
            false
          end
        end
        
        def failure_message
          if @attr.class.eql?(Hash)
            error_msg = "Attribute match error\n"
            @expected.each do |key, val|
               error_msg << " attribute value '#{@attr[key]}' for '#{key}' expecting '#{val}'\n" 
            end
          else
            error_msg = "expected hash for match got '#{@attr.class.name}'"
          end
          error_msg
        end
  
        def description
          "equal attributes"
        end
  
      end
    
      def hav_attributes_with_vales(expected)
        HaveAttributesWithValues.new(expected)
      end
   
  end
end