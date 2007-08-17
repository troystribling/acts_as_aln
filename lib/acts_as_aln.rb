module PlanB #:nodoc
  module Acts #:nodoc
    module Aln #:nodoc

      ####################################################
      def self.included(base)
        base.extend(ClassMethods)  
      end
  
      ####################################################
      module ClassMethods

        def acts_as_aln_resource
          InstanceMethods::AlnResourceMethods.add_methods(self)
        end

      end
  
      ####################################################
      module InstanceMethods

        module AlnResourceMethods
    
          def self.add_methods(target)
    
            target.class_eval <<-do_eval

            do_eval
    
          end           
    
        end

      end
  
      ####################################################
      module SingletonMethods
      end
                
    end   
  end    
end
