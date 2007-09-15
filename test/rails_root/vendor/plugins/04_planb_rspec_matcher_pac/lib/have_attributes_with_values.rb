##############################################################
# match attributes of model against hash of expected values
module PlanB
  
  module SpecMatchers    

      class HaveAttributesWithValues < PlanB::SpecMatchers::ArrayMatcher #:nodoc:
      
        def description
          "match array of hashes"
        end

        def check_expected(val, expt)
          expt.detect{|k, v| not v.eql?(val.attributes[k])}.nil? ? true : false
        end
          
        def write_expected(msg, exp, val)
          super
          exp.each {|k, v| msg <<  " #{k} => #{v}\n"}
        end
        
        def write_value(msg, exp, val)
          super
          exp.each {|k, v| msg <<  " #{k} => #{val.attributes[k]}\n"}
        end
      
      end
    
      def have_attributes_with_values(expected)
        HaveAttributesWithValues.new(expected)
      end
   
  end
end