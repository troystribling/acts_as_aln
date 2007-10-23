require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "adding supported to supporter and accessing supported from supporter that is not persistent", :shared => true do

  it "should be possible add supported individally" do
    @root << @s1
    @root.supported.should include(@s1)
    @root << @s2
    @root.supported.should include(@s2)
    @root << @s3
    @root.supported.should include(@s3)
  end

  it "should be possible add array of supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.should include(@s1)
    @root.supported.should include(@s2)
    @root.supported.should include(@s3)
  end

  it "should be possible to access supported by index" do
    @root << [@s1, @s2, @s3]
    @root.supported[0].should eql(@s1)
    @root.supported[1].should eql(@s2)
    @root.supported[2].should eql(@s3)
  end

  it "should be possible to interate through supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.detect{|s| @s1.eql?(s)}.should eql(@s1)
    @root.supported.detect{|s| @s2.eql?(s)}.should eql(@s2)
    @root.supported.detect{|s| @s3.eql?(s)}.should eql(@s3)
  end
  
end

#########################################################################################################
describe "removing supported from supporter", :shared => true do

  it "should be possible to remove specified supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.delete(@s2)
    @root.supported.should include(@s1)
    @root.supported.should_not include(@s2)
    @root.supported.should include(@s3)
  end

  it "should be possible to remove all supported" do
    @root << [@s1, @s2, @s3]
    @root.supported.clear
    @root.supported.should_not include(@s1)
    @root.supported.should_not include(@s2)
    @root.supported.should_not include(@s3)
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
describe "access to supporter from supported", :shared => true do

  it "should not exist for root that is not persistent" do
    @root.supporter.exists?.should be_false
  end

  it "should not exist for root that is persistent" do
    @root.save
    AlnResource.find(AlnResource.get_as_aln_resource(@root).id).supporter.exists?.should be_false
  end

  it "should be possible to access supporter from supported that is not persistent" do
    @root << [@s1, @s2, @s3]
    p @s1.supporter.id
    @s1.supporter.id.should eql(@root)
#    @s2.supporter.should eql(@root)
#    @s3.supporter.should eql(@root)
  end

  it "should be possible to access supporter from supported is not persistent" do
    @root << [@s1, @s2, @s3]
    @root_chk = AlnResource.find(AlnResource.get_as_aln_resource(@root).id)
    @ar_s1 = AlnResource.get_as_aln_resource(@s1)
    @ar_s2 = AlnResource.get_as_aln_resource(@s2)
    @ar_s3 = AlnResource.get_as_aln_resource(@s3)
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

end


