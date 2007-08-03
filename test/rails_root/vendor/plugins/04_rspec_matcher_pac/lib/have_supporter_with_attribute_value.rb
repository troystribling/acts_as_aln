############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class HasSupporterWithAttributeValue  #:nodoc:
    
        def matches?(mod)
          @mod = mod
          mod.supporter.each do |s, i|
             p s,i
          end
        end
        
        def failure_message
          "#{@mod.class.name} is unable to support descendant relationships\n#{@err_msg}"
        end
  
        def description
          "verify descendant association associations are declared by model"
        end
  
      end
    
      def has_supporter_with_attribute_value
        HasSupporterWithAttributeValue.new
      end
   
  end
end