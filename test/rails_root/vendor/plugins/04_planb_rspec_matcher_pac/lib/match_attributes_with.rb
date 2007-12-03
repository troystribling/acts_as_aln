##############################################################
# match model attributes specified in array
module PlanB
  
  module SpecMatchers    

      class MatchAttributesWith < PlanB::SpecMatchers::ArrayMatcher #:nodoc:

        def initialize(attributes, expected)
          @attributes = attributes
          super(expected)
        end
      
        def description
          "match model attributes specified in array"
        end

        def check_expected(val, expt)
          @attributes.detect {|k| not val.attributes[k].eql?(expt.attributes[k])}.nil? ? true : false
        end
          
        def write_expected(msg, exp, val)
          super
          @attributes.each {|k| msg <<  " #{k} => #{exp.attributes[k.to_s]}\n"}
        end
        
        def write_value(msg, exp, val)
          super
          @attributes.each {|k| msg <<  " #{k} => #{val.attributes[k.to_s]}\n"}
        end
      
      end
    
      def match_attributes_with(attributes, expected)
        MatchAttributesWith.new(attributes, expected)
      end
   
  end
end