####################################################
module PlanB 
  
  ####################################################
  # invalid class specified
  class InvalidClass < ArgumentError; end  

  ####################################################
  module Has 

    ####################################################
    module Ancestor 

      ###################################################
      def self.included(base) #:nodoc
        base.extend(ClassMethods::ActiveRecordBase)  
      end
  
      ###################################################
      module ClassMethods
        
        ###################################################
        module ActiveRecordBase
  
          #################################################
          # Declare a model has descendants.
          def has_descendants

            #### declare active record association
            self.primary_key = "#{self.name.tableize.singularize}_id"
            eval("belongs_to :#{self.name.tableize.singularize}_descendant, :polymorphic => true")

            #### add methods used by both ancestors and descendants
            PlanB::Has::Ancestor::DynamicMethods::AncestorAndDescendant.add_methods(self)
            include(PlanB::Has::Ancestor::InstanceMethods::AncestorAndDescendant)
            extend(PlanB::Has::Ancestor::ClassMethods::AncestorAndDescendant)

            #### add methods used by only ancestors
            PlanB::Has::Ancestor::DynamicMethods::Ancestor.add_methods(self)
            include(PlanB::Has::Ancestor::InstanceMethods::Ancestor)
            extend(PlanB::Has::Ancestor::ClassMethods::Ancestor)

          end
          
          ##################################################
          # Declare a model ancestor.
          def has_ancestor(args = {}) 
           
            #### declare active record association
            args.assert_valid_keys(:named)
            self.primary_key = "#{self.name.tableize.singularize}_id"
            eval("has_one args[:named], :as => :#{args[:named]}_descendant, :dependent => :destroy")

            #### add methods used by both ancestors and descendants
            PlanB::Has::Ancestor::DynamicMethods::AncestorAndDescendant.add_methods(self)
            include(PlanB::Has::Ancestor::InstanceMethods::AncestorAndDescendant)
            extend(PlanB::Has::Ancestor::ClassMethods::AncestorAndDescendant)

            #### add methods used by only desecndants
            PlanB::Has::Ancestor::DynamicMethods::Descendant.add_methods(self, args[:named])
            include(PlanB::Has::Ancestor::InstanceMethods::Descendant)
            extend(PlanB::Has::Ancestor::ClassMethods::Descendant)

          end    
 
        end
                                
      end
  
      ####################################################
      module SingletonMethods #:nodoc :all
      end
                
    end
  end 
     
end