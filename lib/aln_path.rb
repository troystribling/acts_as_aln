class AlnPath < ActiveRecord::Base

  ###############################################################
  #### mixins
  extend AlnHelper
  include AlnTerminationHelper

  ###############################################################
  #### declare descendant associations and ancestor association
  #### with aln_resource
  ###############################################################
  has_descendants
  has_ancestor :named => :aln_resource   

  ###############################################################
  #### declare termination associations with aln_terminations
  ###############################################################
  has_many :aln_terminations, :dependent => :nullify     

  ####################################################################################
  #### add termination to path
  def << (term)    
    add_term = lambda do |t| 
      self.validate_termination(t)
      raise(PlanB::TerminationInvalid, "termination is in different network") unless term.network_id.eql?(self.get_path_network_id(term))
      self.aln_terminations << AlnTermination.to_aln_termination(t)
    end
    term.class.eql?(Array) ? term.each{|t| add_term[t]} : add_term[term]
    self.save
  end  

  ####################################################################################
  #### fetch termination attributes
  def get_path_network_id (term)
    if self.aln_terminations.empty? 
      term.support_hierarchy_root_id
    else
      self.aln_terminations.first.support_hierarchy_root_id
    end  
  end

  ####################################################################################
  # class methods
  class << self            
  end

end
