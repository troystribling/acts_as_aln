require 'acts_as_aln'
require 'aln_resource'
require 'aln_connection'
require 'aln_termination'
ActiveRecord::Base.send(:include, PlanB::Acts::Aln)
