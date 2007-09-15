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
        module Descendant
    
          def self.add_methods(target, parent)

            target.class_eval <<-do_eval
   
              def initialize(*args)
                super(*args)
                get_#{parent}.#{parent}_descendant = self
                descendant_initialize(*args) if respond_to?(:descendant_initialize)
              end
        
              def get_#{parent}
                build_#{parent} if #{parent}.nil?      
                #{parent}
              end

              def get_ancestor
                get_#{parent}      
              end
           
            do_eval
    
          end           
    
        end
        
      end

      ####################################################
      ####################################################
      module InstanceMethods

        ##################################################
        module Descendant
    
          def attributes
            super.merge(get_ancestor.attributes)
          end

          def update
            super
            get_ancestor.update
          end

          def method_missing(meth, *args, &blk)
            meth_class = self.class.ancestor_for_attribute(meth) 
            if meth_class.nil? || meth_class == self.class.name
              begin
                super
              rescue NoMethodError
                if respond_to?(:descendant_method_missing)
                  descendant_method_missing(meth, *args, &blk)
                else
                  get_ancestor.send(meth, *args, &blk)
                end
              end
            else
             if respond_to?(meth_class.tableize.singularize.to_sym)
               get_ancestor.send(meth, *args, &blk)
             else
               descendant_method_missing(meth, *args, &blk)
             end
            end
          end
              
        end
        
      end
      
      ####################################################
      ####################################################
      module ClassMethods

        ##################################################
        module Descendant

          @@finder_data = {}
          def finder_data
            @@finder_data
          end
          
          def method_missing(meth, *args, &blk)
            finder = /^find_(all_by|by)_([_a-zA-Z]*)$/.match(meth.to_s)
            if finder.nil? 
              begin
                super
              rescue NoMethodError
                if respond_to?(:descendant_method_missing)
                  descendant_method_missing(meth, *args, &blk)
                else
                  ancestor.send(meth, *args, &blk)
                end
              end
            else
              generate_finder_method(meth, finder, *args)
            end
          end

          def generate_finder_method(meth, finder, *args)
            finder_type = finder.captures.first == 'all_by' ? :all : :first
            finder_attr = finder.captures.last.split('_and_')
            column_info = columns_hash_hierarchy
            add_finder(meth, finder_type, finder_attr, column_info)
            find_by_attribute_condition(finder_type, finder_attr, column_info, *args)
          end
                      
          def find_by_attribute_condition(finder_type, finder_attr, column_info, *args)
            attr_count = finder_attr.length
            finder_options = args[attr_count]
            finder_cond = " "
            (0..attr_count-1).each do |i|
              finder_cond << ancestor_for_attribute(finder_attr[i].to_sym).tableize + "." +
              finder_attr[i] + " = " + add_attribute(column_info[finder_attr[i]].type, args[i])
              i.eql?(finder_attr.length-1) ? finder_cond << " " : finder_cond << " and " 
            end
            if finder_options.nil?
              finder_options = {:conditions => finder_cond}
            else
              finder_options.include?(:conditions) ? finder_options[:conditions] << ' and ' + finder_cond : finder_options[:conditions] = finder_cond
            end
            find_by_model(finder_type, finder_options)
          end
         
          def add_finder(finder_method, finder_type, finder_attr, column_info)
            @@finder_data[finder_method] = {:finder_type => finder_type, :finder_attr => finder_attr, :column_info => column_info}
            class_eval <<-do_eval
              def self.#{finder_method} (*args)
                finder_params = finder_data["#{finder_method}".to_sym]
                find_by_attribute_condition(finder_params[:finder_type], finder_params[:finder_attr], finder_params[:column_info], *args)
              end
            do_eval
          end
          
          def add_attribute(attr_type, attr)
            case
              when attr_type.eql?(:string) : "'" + attr + "'"
              when attr_type.eql?(:date):  "'" + attr.to_s + "'"
              when attr_type.eql?(:datetime):  "'" + attr.strftime("%y-%m-%d %H:%M:%S") + "'"
              when attr_type.eql?(:time):  "'" + attr.strftime("%H:%M:%S") + "'"
              else attr.to_s
            end
          end
                  
        end
        
      end

    end

  end

end