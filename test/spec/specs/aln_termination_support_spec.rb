require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "adding supported to supporter" do

  it "should should persist supported and supporter when supported is aln_termination decendant model and supporter is aln_resource decendant" do
    root = Nic.new(model_data[:nic_1]) 
    sup = EthernetTermination.new(model_data[:ethernet_termination_1])
    root.should_not persist
    sup.should_not persist
    root << sup
    root.should persist
    AlnResource.to_aln_resource(root).should persist
    sup.should persist
    AlnResource.to_aln_resource(sup).should persist
    AlnTermination.to_aln_termination(sup).should persist
    root.supported(true).should include(AlnResource.to_aln_resource(sup))
    root.destroy
  end

  it "should should persist supported and supporter when supported is aln_termination decendant model and supporter is aln_termination decendant" do
    root = EthernetTermination.new(model_data[:ethernet_termination_1])
    sup = IpTermination.new(model_data[:ip_termination_1])
    root.should_not persist
    sup.should_not persist
    root << sup
    root.should persist
    AlnResource.to_aln_resource(root).should persist
    AlnTermination.to_aln_termination(root).should persist
    sup.should persist
    AlnResource.to_aln_resource(sup).should persist
    AlnTermination.to_aln_termination(sup).should persist
    root.supported(true).should include(AlnResource.to_aln_resource(sup))
    root.destroy
  end

end

