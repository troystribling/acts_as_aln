require 'has_ancestor'
ActiveRecord::Base.send(:include, PlanB::Has::Ancestor)
