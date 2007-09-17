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
    
            add_methods = true
            if target.respond_to?(:ancestor)
              add_methods = false unless target.ancestor.eql?(nil)
            end

            if add_methods

              target.class_eval <<-do_eval
                              
                "#{parent}" != "" ? @@ancestor = eval("#{parent}".classify) : @@ancestor = nil
  
                def self.ancestor
                  @@ancestor
                end          
  
              do_eval
               
            end
            
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
  
          def has_ancestor?
            self.class.has_ancestor?
          end
          
          def has_descendants?
            self.class.has_descendants?
          end

          def descendant_of?(ancestor_model)
            if ancestor_model.nil?
              class_hierarchy.eql?([self.class])
            else
              ancestor_model = ancestor_model.class unless ancestor_model.class.eql?(Class)  
              class_hierarchy.include?(ancestor_model)
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
            ancestor == nil ? [self] : [self] + ancestor.class_hierarchy
          end
          
          def columns_hash_hierarchy
            ancestor.nil? ? columns_hash : columns_hash.merge(ancestor.columns_hash_hierarchy)
          end
          
          def descendant_of?(ancestor_model)
            if ancestor_model.nil?
              class_hierarchy.eql?([self])
            else
              ancestor_model = ancestor_model.class unless ancestor_model.class.eql?(Class)  
              class_hierarchy.include?(ancestor_model)
            end
          end

          def has_ancestor?
            method_defined?(:get_ancestor)
          end
          
          def has_descendants?
            method_defined?(:get_descendant)
          end

          def ancestor_for_attribute(attr)
            class_hierarchy.detect {|c| c.column_names.include?(attr.to_s)}
          end
          
          def find_by_model(*args)
            if args.first.eql?(:first) || args.first.eql?(:all)
              ch = class_hierarchy.collect{|c| c.name.tableize}
              joins = ""
              conditions = ""
              if ch.length > 1
                (0..ch.length-2).each do |i|
                  joins << "LEFT JOIN " + ch[i+1] + " ON " + ch[i+1] + "." + ch[i+1].singularize +
                           "_descendant_id = " + ch[i] + "." + ch[i].singularize + "_id "
                  conditions << ch[i+1] + "." + ch[i+1].singularize + "_descendant_type = '" + ch[i].classify + "'"
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