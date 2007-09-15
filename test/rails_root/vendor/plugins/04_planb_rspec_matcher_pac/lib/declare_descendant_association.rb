############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class DeclareDescendantAssociation  #:nodoc:
    
        def matches?(mod)
          mod.class.eql?(Class) ? @mod_name = @mod.name.tabelize.singularize : @mod_name = @mod.class.name.tabelize.singularize
          result = true
          @err_msg = ""
          unless (mod.respond_to?(:get_descendant))
            @err_msg << "has_descendants not called\n"
            result = false
          end
          unless (mod.columns_hash_hierarchy.include?("#{@mod_name}_descendant_id"))
            @err_msg << "#{@mod_name}_descendant_id not specified\n"
            result = false
          else
            unless (mod.columns_hash_hierarchy["#{@mod_name}_descendant_id"].type.eql?(:integer))
              @err_msg << "#{@mod_name}_descendant_id not not type :integer\n"
              result = false
            end
          end
          unless (mod.columns_hash_hierarchy.include?("#{@mod_name}_descendant_type"))
            @err_msg << "#{@mod_name}_descendant_type not specified\n"
            result = false
          else
            unless (mod.columns_hash_hierarchy["#{@mod_name}_descendant_id"].type.eql?(:string))
              @err_msg << "#{@mod_name}_descendant_type not type :string\n"
              result = false
            end
          end
          result
        end
        
        def failure_message
          "#{@mod_name} does not support descendant relationships\n#{@err_msg}"
        end
  
        def negative_failure_message
          "#{@mod_name} supports descendant relationships\n#{@err_msg}"
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