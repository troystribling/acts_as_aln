############################################################
# verify that model can support descendant associations
module PlanB
  module SpecMatchers    

      class DeclareDescendantAssociation  #:nodoc:
    
        def matches?(mod)
          mod.class.eql?(Class) ? @mod_name = mod.name.tableize.singularize : @mod_name = mod.class.name.tableize.singularize
          result = true
          @err_msg = ""
          add_error = lambda {|msg| @err_msg << msg + "\n"; result = false}
          unless (mod.has_descendants?)
            add_error["has_descendants not called"]            
          end
          descendant_id = "#{@mod_name}_descendant_id"
          unless (mod.columns_hash_hierarchy.include?(descendant_id))
            add_error["#{descendant_id} not specified"]            
          else
            unless (mod.columns_hash_hierarchy[descendant_id].type.eql?(:integer))
              add_error["#{descendant_id} not type :integer"]
            end
          end
          descendant_type = "#{@mod_name}_descendant_type"
          unless (mod.columns_hash_hierarchy.include?(descendant_type))
            add_error["#{descendant_type} not specified"]
          else
            unless (mod.columns_hash_hierarchy[descendant_type].type.eql?(:string))
              add_error["#{descendant_type} not type :string"]
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