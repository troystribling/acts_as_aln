require 'acts_as_aln'
ActiveRecord::Base.send(:include, PlanB::Acts::Aln)
require 'aln_resource'
require 'aln_connection'
require 'aln_termination'
