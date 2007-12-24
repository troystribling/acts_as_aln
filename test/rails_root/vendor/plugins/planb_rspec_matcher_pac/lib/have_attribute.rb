############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class HaveAttribute  #:nodoc:

        def initialize(*attr)
          @attr = attr.first.to_s
          @type = attr.last
        end

        def matches?(mod)
          @mod = mod
          @mod.class.eql?(Class) ? @mod_name = @mod.name : @mod_name = @mod.class.name
          if @mod.columns_hash_hierarchy.include?(@attr)
            @mod.columns_hash_hierarchy[@attr].type.eql?(@type) ? true : false
          else
            false
          end            
        end
        
        def failure_message
          "'#{@mod_name}' does not support attribute '#{@attr}' of type '#{@type}'\n"
        end

        def negative_failure_message
          "'#{@mod_name}' does support attribute '#{@attr}' of type '#{@type}'\n"
        end

        def description
          "verify the existance of specified attribute on object"
        end
  
      end
    
      def have_attribute(*attr)
        HaveAttribute.new(*attr)
      end
   
  end
end