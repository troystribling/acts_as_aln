####################################################
module PlanB 
  
  ####################################################
  module Has 

    ####################################################
    module Ancestor 

      ###################################################
      ####################################################
      module DynamicMethods
        
        ##################################################
        module Ancestor
    
          def self.add_methods(target)
    
            target.class_eval <<-do_eval

              def get_descendant
                #{target.to_s.tableize.singularize}_descendant      
              end
                  
            do_eval
    
          end           
    
        end
  
      end

      ###################################################
      ####################################################
      module InstanceMethods
        module Ancestor          
          def have_descendants?
            true
          end
        end
      end

      ###################################################
      ####################################################
      module ClassMethods
        module Ancestor  
          def have_descendants?
            true
          end
        end
      end
      ##################################################
      ##################################################

    end

  end

end