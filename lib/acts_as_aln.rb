module PlanB #:nodoc

  ####################################################
  # termination configuration error
  class TerminationInvalid < ArgumentError; end  

  module Acts #:nodoc
    module Aln #:nodoc

      ####################################################
      def self.included(base)
        base.extend(ClassMethods)  
      end
  
      ####################################################
      module ClassMethods
      end
  
      ####################################################
      module InstanceMethods
      end
  
      ####################################################
      module SingletonMethods
      end
                
    end   
  end    
end
