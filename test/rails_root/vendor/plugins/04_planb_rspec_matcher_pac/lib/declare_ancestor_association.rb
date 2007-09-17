############################################################
# verify that model has an ancestor association
module PlanB
  module SpecMatchers    

      class DeclareAncestorAssociation  #:nodoc:
    
        def matches?(mod)
          @mod = mod
          @mod.respond_to?(:descendant_of?) ? !@mod.descendant_of?(nil) : false
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
    
      def declare_ancestor_association
        DeclareAncestorAssociation.new
      end
   
  end
end