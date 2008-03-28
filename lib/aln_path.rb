class AlnPath < ActiveRecord::Base

  ###############################################################
  #### mixins
  extend AlnHelper
  include AlnTerminationHelper
  include AlnAggregation

  ###############################################################
  #### declare descendant associations and ancestor association
  #### with aln_resource
  ###############################################################
  has_descendants
  has_ancestor :named => :aln_resource   

  ####################################################################################
  #### aggregation relations
  aggregator_of :aggregated_class => AlnTermination

  ####################################################################################
  #### destroy model and remove from connection ferom terminations
  def destroy
    AlnTermination.find_all_by_aln_path_id(self.aln_path_id, :readonly => false).each {|t| do_remove_from_termination(t)}
    super
  end

  ####################################################################################
  #### remove path from termination
  def do_remove_from_termination (term)
    term.aln_path_id = nil
    term.aln_path = nil
    term.save
  end

  ####################################################################################
  #### add termination to path
  def << (term)    
    add_term = lambda do |t| 
      self.validate_termination(t)
      raise(PlanB::TerminationInvalid, "termination is in different network") unless t.network_id.eql?(self.get_path_network_id(t))
      self.aln_terminations << AlnTermination.to_aln_termination(t)
      t.save
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

    ####################################################################################
    #### return model as aln_path
    def to_aln_path(mod)
      mod.class.eql?(AlnPath) ? mod : mod.aln_path
    end

  end

end
