##############################################################
# match class of obejcr agaist expeceted values
module PlanB
  module SpecMatchers    

      class Persist < PlanB::SpecMatchers::ArrayMatcher #:nodoc:
      
        def description
          "determine if object persists"
        end

        def check_expected(val, expt)
          val.class.exists?(val.id)
        end

        def write_expected(msg, exp, val)
        end
        
        def write_value(msg, exp, val)
          msg << "#{val.class.name}.exists? is '#{val.class.exists?(val.id)}' should be '#{not val.class.exists?(val.id)}'\n"
        end

      end
    
      def persist
        Persist.new(nil)
      end
   
  end
end