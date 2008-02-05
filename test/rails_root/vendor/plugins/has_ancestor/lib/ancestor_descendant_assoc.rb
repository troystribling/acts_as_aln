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

          def self.add_methods(target)
                      
            target.class_eval <<-do_eval

              def self.descendants
                if self.has_descendants?
                  self.find(:all, :select => "DISTINCT " + "#{target.name.tableize.singularize}_descendant_type").collect do |m|
                    eval(m.#{target.name.tableize.singularize}_descendant_type)
                  end
                else
                  []
                end
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
              descendant.nil? ? self : descendant.to_descendant
            else  
              if self.class.name.eql?(arg.to_s.classify)
                self
              else
                descendant.nil? ? raise(PlanB::InvalidClass, "target model is invalid") : descendant.to_descendant(arg)
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
          
          def column_names_hierarchy
            ancestor.nil? ? column_names : column_names + ancestor.column_names_hierarchy
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
            if args.first.eql?(:all) or args.first.eql?(:first)
              args[1].nil? ? args.push(add_options(nil)) : args.push(add_options(args.pop)) 
            end                        
            find(*args)
          end

          def add_options(opts)
            ch = class_hierarchy.collect{|c| c.name.tableize}
            if ch.length > 1
              joins = ""
              conditions = ""              
              (0..ch.length-2).each do |i|
                joins << "LEFT JOIN " + ch[i+1] + " ON " + ch[i+1] + "." + ch[i+1].singularize +
                         "_descendant_id = " + ch[i] + "." + ch[i].singularize + "_id "
                conditions << ch[i+1] + "." + ch[i+1].singularize + "_descendant_type = '" + ch[i].classify + "'"
                conditions << " and " if i < ch.length-2
              end
              opts = {} if opts.nil?
              if opts.include?(:joins) and not opts[:joins].empty?
                opts[:joins] << ' ' + joins 
              else
               opts[:joins] = joins
              end
              if opts.include?(:conditions) and not opts[:conditions].empty?
                opts[:conditions].class.eql?(Array) ? opts[:conditions].first << ' and ' + conditions : opts[:conditions] << ' and ' + conditions
              else
                opts[:conditions] = conditions
              end
            end
            opts
          end

        end
          
      end
      ##################################################
      ##################################################

    end

  end

end