##############################################################
# match arrays of expected and values

module PlanB
  module SpecMatchers    

      class ArrayMatcher  #:nodoc:
    
        attr_reader :expected_error, :expected, :msg_error, :not_matched, :value
        
        def initialize(expected)
          @expected = expected
          @expected_error = @expected
        end
    
        def matches?(val)          
          @value = val
          @not_matched = Array.new(value.length, true) if @value.class.eql?(Array)
          if @value.class.eql?(Array) and not @expected.class.eql?(Array)
            check_values(@expected, false)
          elsif not @value.class.eql?(Array) and @expected.class.eql?(Array)
            @expected.detect do |e| 
              check_expected(@value, e).eql?(true)
            end.nil? ? false : true              
          elsif @value.class.eql?(Array) and @expected.class.eql?(Array) 
            if @value.length.eql?(@expected.length)
              @expected.detect do |e| 
                check_values(e, true).eql?(false)
              end.nil? ? true : false
            else
              @msg_error = "Expected:\n  array length=#{@expected.length}\n" + "Got:\n  array length=#{@value.length}\n"
              false
            end
          else
            check_expected(@value, @expected)
          end
        end
        
        def check_values(expt, cond)
          match_index = (0..@value.length-1).detect {|i| check_expected(@value[i], expt).eql?(cond) and @not_matched[i]}
          if match_index.nil?
            not cond
          else
            @not_matched[match_index] = false
            cond
          end
        end
        
        def message(msg)
          if @value.class.eql?(Array) and not @expected.class.eql?(Array)
            @value.each {|v| write_expected(msg, @expected, v)}
            @value.each {|v| write_value(msg, @expected, v)}
          elsif not @value.class.eql?(Array) and @expected.class.eql?(Array)
            @expected.each {|e| write_expected(msg, e, @value)}
            @expected.each {|e| write_value(msg, e, @value)}
          elsif @value.class.eql?(Array) and @expected.class.eql?(Array) 
            (0..@expected.length-1).each {|i| write_expected(msg, @expected[i], @value[i])}
            (0..@expected.length-1).each {|i| write_value(msg, @expected[i], @value[i])}
          else
            write_expected(msg, @expected, @value)
            write_value(msg, @expected, @value)
          end
          msg
        end

        def failure_message
          @msg_error.nil? ? message("Match Failure\n") : @msg_error
        end
  
        def negative_failure_message
          message("Matched\n")
        end
  
        def description
          "match array of scalars"
        end

        def check_expected(val, expt)
          expt.eql?(val)
        end

        def write_expected(msg, exp, val)
          msg << "Expected:\n"
        end
        
        def write_value(msg, exp, val)
          msg << "Got:\n"
        end
        
      end
    
      def array_matcher(expected)
        ArrayMatcher.new(expected)
      end
   
  end
end