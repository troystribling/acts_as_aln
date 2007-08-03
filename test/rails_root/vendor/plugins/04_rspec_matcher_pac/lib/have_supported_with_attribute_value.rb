############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class HaveSupportedWithAttributeValue  #:nodoc:

        def initialize(*exp)
          @supporter_attr = exp[0]
          @supporter_attr_val = exp[1]
        end

        def matches?(mod)
          @mod = mod
          result = @mod.supported.detect do |m|
            @supporter_attr_val == m.send(@supporter_attr)
          end
          result.nil? ? false : true
        end
        
        def failure_message
          "supporter with attribute \'#{@supporter_attr}\' = \'#{@supporter_attr_val}\' not found"
        end
  
        def negative_failure_message
          "supporter with attribute \'#{@supporter_attr}\' = \'#{@supporter_attr_val}\' found"
        end

        def description
          "locate specified supporter"
        end
  
      end
    
      def have_supported_with_attribute_value(*exp)
        HaveSupportedWithAttributeValue.new(*exp)
      end
   
  end
end