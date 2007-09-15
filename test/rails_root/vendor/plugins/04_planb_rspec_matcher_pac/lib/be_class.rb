##############################################################
# match class of obejcr agaist expeceted values
module PlanB
  module SpecMatchers    

      class BeClass < PlanB::SpecMatchers::ArrayMatcher #:nodoc:
      
        def description
          "match array of classes"
        end

        def check_expected(val, expt)
          expt.eql?(val.class)
        end

        def write_expected(msg, exp, val)
          super
          msg << " #{exp}\n"
        end
        
        def write_value(msg, exp, val)
          super
          msg << " #{val.class}\n"
        end

      end
    
      def be_class(expected)
        BeClass.new(expected)
      end
   
  end
end