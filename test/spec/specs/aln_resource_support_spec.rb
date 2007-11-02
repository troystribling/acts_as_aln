require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "adding supported to supporter and accessing supported from supporter that is not persistent", :shared => true do

  it "should be possible to add supported individally" do
    @root << @s1
    @root.supported.should include(AlnResource.get_as_aln_resource(@s1))
    @root << @s2
    @root.supported.should include(AlnResource.get_as_aln_resource(@s2))
    @root << @s3
    @root.supported.should include(AlnResource.get_as_aln_resource(@s3))
  end

  it "should be possible to add array of supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.should include(AlnResource.get_as_aln_resource(@s1))
    @root.supported.should include(AlnResource.get_as_aln_resource(@s2))
    @root.supported.should include(AlnResource.get_as_aln_resource(@s3))
  end

  it "should be possible to access supported by index" do
    @root << [@s1, @s2, @s3]
    @root.supported[0].should eql(AlnResource.get_as_aln_resource(@s1))
    @root.supported[1].should eql(AlnResource.get_as_aln_resource(@s2))
    @root.supported[2].should eql(AlnResource.get_as_aln_resource(@s3))
  end

  it "should be possible to interate through supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.detect{|s| AlnResource.get_as_aln_resource(@s1).eql?(s)}.should eql(AlnResource.get_as_aln_resource(@s1))
    @root.supported.detect{|s| AlnResource.get_as_aln_resource(@s2).eql?(s)}.should eql(AlnResource.get_as_aln_resource(@s2))
    @root.supported.detect{|s| AlnResource.get_as_aln_resource(@s3).eql?(s)}.should eql(AlnResource.get_as_aln_resource(@s3))
  end

  it "should be possible to convert supported to array" do
    @root.supported.to_array.class.should eql(Array)
  end
  
end

#########################################################################################################
describe "removing supported from supporter", :shared => true do

  it "should be possible to remove specified supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.delete(AlnResource.get_as_aln_resource(@s2))
    @root.supported.should include(AlnResource.get_as_aln_resource(@s1))
    @root.supported.should_not include(AlnResource.get_as_aln_resource(@s2))
    @root.supported.should include(AlnResource.get_as_aln_resource(@s3))
  end

  it "should be possible to remove all supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.clear
    @root.supported.should_not include(AlnResource.get_as_aln_resource(@s1))
    @root.supported.should_not include(AlnResource.get_as_aln_resource(@s2))
    @root.supported.should_not include(AlnResource.get_as_aln_resource(@s3))
  end

end

#########################################################################################################
describe "return value of supported from supported with no supported", :shared => true do

  it "should be empty array" do
    @root.supported.should be_empty
  end

end

#########################################################################################################
describe "accessing supported from supporter that is persistent", :shared => true do

  def save_root
    @root << [@s1, @s2, @s3]
    @root_chk = AlnResource.find(AlnResource.get_as_aln_resource(@root).id)
    @ar_s1 = AlnResource.get_as_aln_resource(@s1)
    @ar_s2 = AlnResource.get_as_aln_resource(@s2)
    @ar_s3 = AlnResource.get_as_aln_resource(@s3)
  end
  
  it "should be possible to access supported by index" do
    save_root
    @root_chk.supported[0].should eql(@ar_s1)
    @root_chk.supported[1].should eql(@ar_s2)
    @root_chk.supported[2].should eql(@ar_s3)
  end

  it "should be possible to interate through supported" do
    save_root
    @root_chk.supported.detect{|s| @ar_s1.eql?(s)}.should eql(@ar_s1)
    @root_chk.supported.detect{|s| @ar_s1.eql?(s)}.should eql(@ar_s1)
    @root_chk.supported.detect{|s| @ar_s1.eql?(s)}.should eql(@ar_s1)
  end

end

#########################################################################################################
describe "retrieving supported count", :shared => true do

  it "should be zero when there are no supported" do
    @root.supported.count.should eql(0)
  end

  it "should equal supported count" do
    @root << [@s1, @s2, @s3]
    @root.supported.count.should eql(3)
  end

end

#########################################################################################################
describe "force load of array of supported from database", :shared => true do

  it "should be and option when an element of supported updated" do
    @root << [@s1, @s2, @s3]
    s1_update = AlnResource.find(AlnResource.get_as_aln_resource(@s1).id)
    @root.supported.first.resource_name.should eql(s1_update.resource_name)
    s1_update.resource_name = 'new_name'
    s1_update.save
    @root.supported.first.resource_name.should_not eql(s1_update.resource_name)
    @root.supported(true).first.resource_name.should eql(s1_update.resource_name)
  end

end

#########################################################################################################
describe "access to supporter from supported", :shared => true do

  it "should be nil for root that is not persistent" do
    @root.supporter.should be_nil
  end

  it "should not exist for root that is persistent" do
    @root.save
    AlnResource.find(AlnResource.get_as_aln_resource(@root).id).supporter.should be_nil
  end

  it "should be possible to access supporter from supported that is not persistent" do
    @root << [@s1, @s2, @s3]
    @s1.supporter.id.should eql(AlnResource.get_as_aln_resource(@root).id)
    @s2.supporter.id.should eql(AlnResource.get_as_aln_resource(@root).id)
    @s3.supporter.id.should eql(AlnResource.get_as_aln_resource(@root).id)
  end

  it "should be possible to access supporter from supported is not persistent" do
    @root << [@s1, @s2, @s3]
    @chk_s1 = AlnResource.find(AlnResource.get_as_aln_resource(@s1).id)
    @chk_s2 = AlnResource.find(AlnResource.get_as_aln_resource(@s2).id)
    @chk_s3 = AlnResource.find(AlnResource.get_as_aln_resource(@s3).id)
    @chk_s1.supporter.id.should eql(AlnResource.get_as_aln_resource(@root).id)
    @chk_s2.supporter.id.should eql(AlnResource.get_as_aln_resource(@root).id)
    @chk_s3.supporter.id.should eql(AlnResource.get_as_aln_resource(@root).id)
  end

end

#########################################################################################################
describe "accessing supported from aln_resource supporter" do

  before(:each) do
    @root = AlnResource.new(model_data[:aln_resource])
    @s1 = AlnResource.new(model_data[:aln_resource_supported_1])
    @s2 = AlnResource.new(model_data[:aln_resource_supported_2])
    @s3 = AlnResource.new(model_data[:aln_resource_supported_1])
  end
  
  after(:each) do
    @root.destroy
    @s1.destroy
    @s2.destroy
    @s3.destroy
  end  
    
  it_should_behave_like "adding supported to supporter and accessing supported from supporter that is not persistent"

  it_should_behave_like "removing supported from supporter"

  it_should_behave_like "accessing supported from supporter that is persistent"

  it_should_behave_like "retrieving supported count"

  it_should_behave_like "access to supporter from supported"

  it_should_behave_like "force load of array of supported from database"

end

#########################################################################################################
describe "accessing supported from aln_resource descendant supporter" do

  before(:each) do
    @root = AlnTermination.new(model_data[:aln_termination])
    @s1 = AlnTermination.new(model_data[:aln_termination_supported_1])
    @s2 = AlnTermination.new(model_data[:aln_termination_supported_2])
    @s3 = AlnTermination.new(model_data[:aln_termination_supported_1])
  end

  after(:each) do
    @root.destroy
    @s1.destroy
    @s2.destroy
    @s3.destroy
  end  

  it_should_behave_like "adding supported to supporter and accessing supported from supporter that is not persistent"

  it_should_behave_like "removing supported from supporter"

  it_should_behave_like "accessing supported from supporter that is persistent"

  it_should_behave_like "retrieving supported count"

  it_should_behave_like "access to supporter from supported"

  it_should_behave_like "force load of array of supported from database"

end

