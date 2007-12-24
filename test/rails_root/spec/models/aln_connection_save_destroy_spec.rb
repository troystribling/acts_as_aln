require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "persitence of aln_connection", :shared => true do

  it "should occur when a termination is added to connection" do
    @c.should_not persist
    @c << @t
    @c.should persist
  end
  
end

#########################################################################################################
describe "destruction of aln_connection", :shared => true do
 
  def create_destroy_connection
    @c << @t
    @c.should persist
    AlnResource.to_aln_resource(@t).should persist
    AlnTermination.to_aln_termination(@t).should persist
    @t.should persist
    @c.destroy
    @c.should_not persist
    AlnResource.to_aln_resource(@t).should persist
    AlnTermination.to_aln_termination(@t).should persist
    @t.should persist
  end
  
  it "should not destroy contained terminations" do
    create_destroy_connection
  end

  it "should set termination connection association to nil" do
    create_destroy_connection
    @t.reload
    @t.aln_connection_id.should be_nil
    @t.aln_connection.should be_nil
  end

end

#########################################################################################################
describe "persistence of terminations from aln_connection", :shared => true do

  it "should occur when a termination is added to connection" do
    @t.should_not persist
    @c << @t
    @t.should persist
  end

end

#########################################################################################################
describe "management of aln_terminations in a connection" do

  before(:each) do
    @t = AlnTermination.new(model_data[:aln_termination_supported_1])
    @c = AlnConnection.new(:termination_type => :aln_termination)
  end
  
  after(:each) do
    @t.destroy
    @c.destroy
  end

  it_should_behave_like "persitence of aln_connection"

  it_should_behave_like "destruction of aln_connection"

  it_should_behave_like "persistence of terminations from aln_connection"

end

#########################################################################################################
describe "management of aln_termination descendants in a connection" do

  before(:each) do
    @t = IpTermination.new(model_data[:ip_termination_remove_1])
    @c = AlnConnection.new(:termination_type => :ip_termination)
  end

  after(:each) do
    @t.destroy
    @c.destroy
  end

  it_should_behave_like "persitence of aln_connection"

  it_should_behave_like "destruction of aln_connection"

  it_should_behave_like "persistence of terminations from aln_connection"

end
