require 'meta_class.rb'
require 'ancestor_assoc'
require 'descendant_assoc'
require 'ancestor_descendant_assoc'
require 'has_ancestor'
ActiveRecord::Base.send(:include, PlanB::Has::Ancestor)
