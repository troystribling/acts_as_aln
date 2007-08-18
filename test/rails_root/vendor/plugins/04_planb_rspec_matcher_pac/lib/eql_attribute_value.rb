############################################################
# match attribute of models against expected value
module PlanB
  module SpecMatchers    

      class EqlAttributeValue  #:nodoc:
    
        def initialize(*exp)
          @mod_attr = exp[0]
          @attr_val = exp[1]
        end
    
        def matches?(mods)
          @mods = mods
          result = @mods.find do |m|
            @attr_val != m.send(@mod_attr)
          end
          result.nil? && mods.size > 1 ? true : false
        end
        
        def failure_message
          error_msg = "Model attribute value error\n"
          error_msg = "Number of models is '#{@mods.size}' expecting more than 1\n"
          @mods.each do |m|
             mod_val = m.send(@mod_attr)
             error_msg << "-for model '#{m.class.name}'\n" 
             error_msg << "  attribute value '#{mod_val}' for '#{@mod_attr.to_s}' expecting '#{@attr_val}'\n" 
          end
          error_msg
        end
  
        def description
          "eql attribute values"
        end
  
      end
    
      def eql_attribute_value(*exp)
        EqlAttributeValue.new(*exp)
      end
   
  end
end