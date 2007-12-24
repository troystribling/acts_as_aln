############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class HaveMethod  #:nodoc:

        def initialize(meth)
          @method = meth
        end

        def matches?(mod)
          @mod = mod
          @mod.respond_to?(@method)
        end
        
        def failure_message
          "#{@mod.class.name} does not support '#{@method.to_s}'\n"
        end

        def negative_failure_message
          "#{@mod.class.name} supports '#{@method.to_s}'\n"
        end

        def description
          "verify the existance of specified method on object"
        end
  
      end
    
      def have_method(meth)
        HaveMethod.new(meth)
      end
   
  end
end