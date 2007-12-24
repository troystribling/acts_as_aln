require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "persitence of aln_path", :shared => true do

  it "should occur when a termination is added to connection" do
    @p.should_not persist
    @p << @t
    @p.should persist
  end
  
end

#########################################################################################################
describe "destruction of aln_path", :shared => true do
 
  def create_destroy_path
    @p << @t
    @p.should persist
    AlnResource.to_aln_resource(@t).should persist
    AlnTermination.to_aln_termination(@t).should persist
    @t.should persist
    @p.destroy
    @p.should_not persist
    AlnResource.to_aln_resource(@t).should persist
    AlnTermination.to_aln_termination(@t).should persist
    @t.should persist
  end
  
  it "should not destroy contained terminations" do
    create_destroy_path
  end

  it "should set termination path association to nil" do
    create_destroy_path
    @t.reload
    @t.aln_path_id.should be_nil
    @t.aln_path.should be_nil
  end

end

#########################################################################################################
describe "persistence of terminations from aln_path", :shared => true do

  it "should occur when a termination is added to path" do
    @t.should_not persist
    @p << @t
    @t.should persist
  end

end

#########################################################################################################
describe "management of aln_terminations in a connection" do

  before(:each) do
    @t = AlnTermination.new(model_data[:aln_termination_supported_1])
    @p = AlnPath.new(:termination_type => :aln_termination)
  end
  
  after(:each) do
    @t.destroy
    @p.destroy
  end

  it_should_behave_like "persitence of aln_path"

  it_should_behave_like "destruction of aln_path"

  it_should_behave_like "persistence of terminations from aln_path"

end

#########################################################################################################
describe "management of aln_termination descendants in a connection" do

  before(:each) do
    @t = IpTermination.new(model_data[:ip_termination_remove_1])
    @p = AlnPath.new(:termination_type => :ip_termination)
  end

  after(:each) do
    @t.destroy
    @p.destroy
  end

  it_should_behave_like "persitence of aln_path"

  it_should_behave_like "destruction of aln_path"

  it_should_behave_like "persistence of terminations from aln_path"

end
