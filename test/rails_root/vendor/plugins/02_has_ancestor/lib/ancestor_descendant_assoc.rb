####################################################
module PlanB 
  
  ####################################################
  module Has 

    ####################################################
    module Ancestor 

      ####################################################
      ####################################################
      module DynamicMethods

        ##################################################
        module AncestorAndDescendant

          def self.add_methods(target, parent)
    
             target.class_eval <<-do_eval
                            
               "#{parent}" != "" ? @@ancestor_class = eval("#{parent}".classify) : @@ancestor_class = nil

               def self.ancestor
                 @@ancestor_class
               end          

             do_eval

          end
          
        end

      end

      ####################################################
      ####################################################
      module InstanceMethods

        ##################################################
        module AncestorAndDescendant

          def class_hierarchy
            self.class.class_hierarchy
          end

          def columns_hash_hierarchy
            self.class.columns_hash_hierarchy
          end

          def to_descendant(arg = nil)
            if arg.nil?
              if descendant.nil?
                self
              else
                descendant.to_descendant
              end
            else  
              if self.class.name.eql?(arg.to_s.classify)
                self
              else
                if descendant.nil?
                  raise(PlanB::InvalidClass, "target model is invalid")
                else
                  descendant.to_descendant(arg)
                end
              end
            end
          end

          def descendant
            respond_to?(:get_descendant) ? get_descendant : nil
          end
  
          def ancestor
            respond_to?(:get_ancestor) ? get_ancestor : nil
          end
  
          def descendant_of?(ancestor_model)
            if ancestor_model.nil?
              class_hierarchy.eql?([self.class.name])
            else
              ancestor_model.class.eql?(Class) ? ancestor_name = ancestor_model.name : ancestor_name = ancestor_model.class.name
              class_hierarchy.include?(ancestor_name)
            end
          end
         
        end
        
      end

      ####################################################
      ####################################################
      module ClassMethods

        ##################################################
        module AncestorAndDescendant

          def class_hierarchy
            ancestor == nil ? [name] : [name] + ancestor.class_hierarchy
          end
          
          def columns_hash_hierarchy
            ancestor.nil? ? columns_hash : columns_hash.merge(ancestor.columns_hash_hierarchy)
          end
          
          def descendant_of?(ancestor_model)
            if ancestor_model.nil?
              class_hierarchy.eql?([name])
            else
              ancestor_model.class.eql?(Class) ? ancestor_name = ancestor_model.name : ancestor_name = ancestor_model.class.name
              class_hierarchy.include?(ancestor_name)
            end
          end

          def ancestor_for_attribute(attr)
            class_hierarchy.detect {|c| eval(c).column_names.include?(attr.to_s)}
          end
          
          def find_by_model(*args)
            if args.first.eql?(:first) || args.first.eql?(:all)
              ch = class_hierarchy
              joins = ""
              conditions = ""
              if ch.length > 1
                (0..ch.length-2).each do |i|
                  joins << "LEFT JOIN " + ch[i+1].tableize + " ON " + ch[i+1].tableize + "." + ch[i+1].tableize.singularize +
                           "_descendant_id = " + ch[i].tableize + "." + ch[i].tableize.singularize + "_id "
                  conditions << ch[i+1].tableize + "." + ch[i+1].tableize.singularize + "_descendant_type = '" + ch[i] + "'"
                  conditions << " and " if i < ch.length-2
                end
                if args[1].nil?
                  args[1] = {:conditions => conditions, :joins => joins}
                else
                  args[1].include?(:joins) ?  args[1][:joins] << ' ' + joins : args[1][:joins] = joins
                  args[1].include?(:conditions) ? args[1][:conditions] << ' and ' + conditions : args[1][:conditions] = conditions
                end
              end  
            end
            find(*args)
          end

        end
          
      end
      ##################################################
      ##################################################

    end

  end

end