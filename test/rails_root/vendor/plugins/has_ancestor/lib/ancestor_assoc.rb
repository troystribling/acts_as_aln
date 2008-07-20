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

            unless target.respond_to?(:ancestor)
    
              target.class_eval <<-do_eval
  
                @@ancestor = nil
  
                def self.ancestor
                  @@ancestor
                end          
  
              do_eval

              target.class_eval <<-do_eval
  
                def get_descendant
                  #{target.to_s.underscore}_descendant      
                end
                    
              do_eval
            
            end
    
          end           
    
        end
  
      end

      ###################################################
      ####################################################
      module InstanceMethods
        module Ancestor          
        end
      end

      ###################################################
      ####################################################
      module ClassMethods
        module Ancestor  
        end
      end
      ##################################################
      ##################################################

    end

  end

end