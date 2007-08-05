############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class DeclareDescendantAssociation  #:nodoc:
    
        def matches?(mod)
          @mod = mod
          mod_name = @mod.class.name.tableize.singularize
          result = true
          @err_msg = ""
          unless (@mod.respond_to?(:get_descendant))
            @err_msg << "has_descendants not called\n"
            result = false
          end
          unless (@mod.respond_to?("#{mod_name}_descendant_id".to_sym))
            @err_msg << "#{mod_name}_descendant_id not specified\n"
            result = false
          else
            unless (eval("@mod.column_for_attribute('#{mod_name}_descendant_id').type").eql?(:integer))
              @err_msg << "#{mod_name}_descendant_id not not type :integer\n"
              result = false
            end
          end
          unless (@mod.respond_to?("#{mod_name}_descendant_type".to_sym))
            @err_msg << "#{mod_name}_descendant_type not specified\n"
            result = false
          else
            unless (eval("@mod.column_for_attribute('#{mod_name}_descendant_type').type").eql?(:string))
              @err_msg << "#{mod_name}_descendant_type not type :string\n"
              result = false
            end
          end
          result
        end
        
        def failure_message
          "#{@mod.class.name} is unable to support descendant relationships\n#{@err_msg}"
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