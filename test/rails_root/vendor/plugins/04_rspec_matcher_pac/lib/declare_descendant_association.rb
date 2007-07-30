############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class DeclareDescendantAssociation  #:nodoc:
    
        def matches?(mod)
          @mod = mod
          mod_name = @mod.class.name.tableize.singularize
          if (
               @mod.respond_to?(:get_descendant) &&
               @mod.respond_to?("#{mod_name}_descendant_id".to_sym) &&
               @mod.respond_to?("#{mod_name}_descendant_type".to_sym)
              )
            true
          else
            false
          end
        end
        
        def failure_message
          "#{@mod.class.name} is unable to support descendant relationships"
        end
  
        def description
          "verify descendant association associations are declared by model"
        end
  
      end
    
      def declare_descendant_association
        DeclareDescendantAssociation.new
      end
   
  end
end