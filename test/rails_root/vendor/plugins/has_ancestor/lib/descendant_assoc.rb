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

            unless target.has_ancestor?
            
              target.class_eval <<-do_eval

                @@ancestor = eval("#{parent}".classify)
  
                def self.ancestor
                  @@ancestor
                end          
  
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
            if meth_class.nil? or meth_class.eql?(self.class)
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
              get_ancestor.send(meth, *args, &blk)
            end
          end
              
        end
        
      end
      
      ####################################################
      ####################################################
      module ClassMethods

        ##################################################
        module Descendant
          
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
            curry_finder = lambda{|t, a, c| lambda {|*args| find_by_attribute_condition(t, a, c, *args)}}
            define_meta_class_method(meth, &curry_finder[finder_type, finder_attr, column_info])
            find_by_attribute_condition(finder_type, finder_attr, column_info, *args)
          end
                      
          def find_by_attribute_condition(finder_type, finder_attr, column_info, *args)
            attr_count = finder_attr.length
            finder_options = args[attr_count]
            finder_cond = " "
            (0..attr_count-1).each do |i|
              finder_cond << ancestor_for_attribute(finder_attr[i].to_sym).name.tableize + "." + finder_attr[i] + " = ? "
              i.eql?(finder_attr.length-1) ? finder_cond << " " : finder_cond << " and " 
            end
            if finder_options.nil?
              finder_options = {:conditions => [finder_cond] + args[0..attr_count-1]}
            else
              if finder_options.include?(:conditions)
                if finder_options[:conditions].class.eql?(Array)
                  finder_options[:conditions].first << ' and ' + finder_cond
                  finder_options[:conditions] += args[0..attr_count-1]
                else
                  finder_options[:conditions] = [finder_options[:conditions] << ' and ' + finder_cond] + args[0..attr_count-1]
                end
              else
                finder_options[:conditions] = finder_cond
              end
            end
            find_by_model(finder_type, finder_options)
          end
                             
        end
        
      end

    end

  end

end