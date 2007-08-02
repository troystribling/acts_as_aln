############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class HaveAncestorAssociation  #:nodoc:
    
        def matches?(mod)
          @mod = mod
          @mod.respond_to?(:get_ancestor) ? true : false
        end
        
        def failure_message
          "#{@mod.class.name} does not support ancestor relationship\n"
        end

        def negative_failure_message
          "#{@mod.class.name} supports ancestor relationship\n"
        end

        def description
          "verify the existance of ancestor association"
        end
  
      end
    
      def have_ancestor_association
        HaveAncestorAssociation.new
      end
   
  end
end