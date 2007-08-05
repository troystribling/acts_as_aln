module PlanB #:nodoc
  module Acts #:nodoc
    module Aln #:nodoc

      ####################################################
      def self.included(base)
        base.extend(ClassMethods)  
      end
  
      ####################################################
      module ClassMethods

        def acts_as_supporter(params)
          InstanceMethods::AlnSupporterMethods.add_methods(self, params)
        end

      end
  
      ####################################################
      module InstanceMethods

        module AlnSupporterMethods
    
          def self.add_methods(target, params)
    
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
