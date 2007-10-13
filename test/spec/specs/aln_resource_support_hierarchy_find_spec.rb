require File.dirname(__FILE__) + '/../spec_helper'

#########################################################################################################
describe "queries for root of support hierarcy" do

  it "should find root when root is aln_resource model" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
    root_chk.id.should be(root.id)
    root_chk.class.should be(AlnResource)
    root_chk.should have_attributes_with_values(model_data[:aln_resource])
    root_chk.supporter.should be_nil
    root_chk.destroy
  end

  it "should find root when root is an aln_resource descendant model" do 
    root = AlnTermination.new(model_data[:aln_termination])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnTermination.find_support_root_by_model(AlnTermination, :first)
    root_chk.id.should be(root.id)
    root_chk.class.should be(AlnTermination)
    root_chk.should have_attributes_with_values(model_data[:aln_termination])
    root_chk.supporter.should be_nil
    root_chk.destroy
  end

  it "should find root as aln_resource when root is an aln_resource descendant model" do 
    root = AlnTermination.new(model_data[:aln_termination])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnResource.find_support_root_by_model(AlnResource, :first)
    root_chk.id.should be(root.aln_resource.id)
    root_chk.class.should be(AlnResource)
    root_chk.to_descendant.should have_attributes_with_values(model_data[:aln_termination])
    root_chk.supporter.should be_nil
    root_chk.destroy
  end

  it "should find all roots when multiple aln_resource roots exist" do 
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root << AlnResource.new(model_data[:aln_resource_supported_1])
    root.save
    root = AlnResource.new(model_data[:aln_resource])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnResource.find_support_root_by_model(AlnResource, :all)
    root_chk.length.should be(2)
    root_chk.each do |r|
      r.should have_attributes_with_values(model_data[:aln_resource])
      r.supporter.should be_nil
      r.class.should be(AlnResource)
      r.destroy
    end
  end

  it "should find all roots as aln_resorce when multiple aln_resource descendant roots exist" do 
    root = AlnTermination.new(model_data[:aln_termination])
    root << AlnTermination.new(model_data[:aln_termination_supported_1])
    root << AlnTermination.new(model_data[:aln_termination_supported_1])
    root.save
    root = AlnTermination.new(model_data[:aln_termination])
    root << AlnTermination.new(model_data[:aln_termination_supported_2])
    root << AlnTermination.new(model_data[:aln_termination_supported_2])
    root.save
    root = AlnConnection.new(model_data[:aln_connection])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnResource.find_support_root_by_model(AlnResource, :all)
    root_chk.length.should be(3)
    root_chk.each do |r|
      r.should have_attributes_with_values(model_data[:aln_termination_resource]) if r.descendant.class.eql?(AlnTermination)
      r.should have_attributes_with_values(model_data[:aln_connection_resource]) if r.descendant.class.eql?(AlnConnection)
      r.supporter.should be_nil
      r.class.should be(AlnResource)
      r.destroy
    end
  end

  it "should find all roots as specified descendant type when roots exist of multiple aln_resource descendant types" do 
    root = AlnTermination.new(model_data[:aln_termination])
    root << AlnTermination.new(model_data[:aln_termination_supported_1])
    root << AlnTermination.new(model_data[:aln_termination_supported_1])
    root.save
    root = AlnTermination.new(model_data[:aln_termination])
    root << AlnTermination.new(model_data[:aln_termination_supported_2])
    root << AlnTermination.new(model_data[:aln_termination_supported_2])
    root.save
    root_con = AlnConnection.new(model_data[:aln_connection])
    root_con << AlnResource.new(model_data[:aln_resource_supported_2])
    root_con << AlnResource.new(model_data[:aln_resource_supported_2])
    root_con.save
    root_chk = AlnTermination.find_support_root_by_model(AlnTermination, :all)
    root_chk.length.should be(2)
    root_chk.each do |r|
      r.should have_attributes_with_values(model_data[:aln_termination])
      r.supporter.should be_nil
      r.class.should be(AlnTermination)
      r.destroy
    end
    root_con.destroy
  end

end

#########################################################################################################
describe "queries for directly supported from supporter", :shared => true do

  it "should find all supported of specified return models as aln_reasource" do 
    @root.supported.should have_attributes_with_values([model_data[:aln_termination_resource_supported_1], model_data[:aln_termination_resource_supported_2], model_data[:aln_resource_supported_1], model_data[:aln_resource_supported_2]])
    @root.supported.should be_class(AlnResource)
  end

  it "should find first supported of specified model type and return models as specified type" do 
    mod = @root.find_supported_by_model(AlnTermination, :first)
    mod.should have_attributes_with_values(model_data[:aln_termination_supported_1])
    mod.should be_class(AlnTermination)
  end

  it "should find first supported of specified model type that matches a specified attribute and return models as specified type" do 
    mod = @root.find_supported_by_model(AlnTermination, :first, :conditions => "aln_resources.resource_name = '#{model_data[:aln_termination_supported_2]['resource_name']}'")
    mod.should have_attributes_with_values(model_data[:aln_termination_supported_2])
    mod.should be_class(AlnTermination)
  end

  it "should find all supported of specified model type and return models as specified type" do 
    mods = @root.find_supported_by_model(AlnTermination, :all)
    mods.should have_attributes_with_values([model_data[:aln_termination_supported_1], model_data[:aln_termination_supported_2]])
    mods.should be_class(AlnTermination)
  end

  it "should find all supported of specified model type that matches a specified condition and return models as specified type" do 
    mods = @root.find_supported_by_model(AlnTermination, :all, :conditions => "aln_terminations.directionality = '#{model_data[:aln_termination_supported_2]['directionality']}'")
    mods.should have_attributes_with_values([model_data[:aln_termination_supported_1], model_data[:aln_termination_supported_2]])
    mods.should be_class(AlnTermination)
  end
  
end

##########################################################################################################
describe "queries for directly supported from aln_resource supporter" do

  before(:each) do
    root = AlnResource.new(model_data[:aln_resource])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.save
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end

  after(:each) do
    @root.destroy   
  end
  
  it_should_behave_like "queries for directly supported from supporter"
    
end

##########################################################################################################
describe "queries for directly supported from aln_resource descendant supporter" do

  before(:each) do
    root = AlnTermination.new(model_data[:aln_termination])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.save
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:each) do
    @root.destroy   
  end
  
  it_should_behave_like "queries for directly supported from supporter"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1", :shared => true  do

  it "should find first supported for aln_resource models" do
    p @root.find_by_model_in_support_hierarchy(AlnResource, :first) 
  end

  it "should find first supported of the specified aln_resource descendant model" do 
#    p @root.find_model_in_support_hierarchy(AlnTermination, :first) 
  end
  
  it "should find all supported aln_resource models" do 
  end

  it "should find all supported of the specified aln_resource descendant model" do 
  end

end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 1", :shared => true  do

  it "should find first supported for aln_resource models" do
  end

  it "should find first supported of the specified aln_resource descendant model" do 
  end
  
  it "should find all supported aln_resource models" do 
  end

  it "should find all supported of the specified aln_resource descendant model" do 
  end

end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 0", :shared => true  do

end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1 for aln_resource root"  do
  
  before(:each) do
    root = AlnResource.new(model_data[:aln_resource])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.first.supported.last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.last.supported.last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.save_hierarchy
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end
  
  after(:each) do
    @root.destroy
  end

  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1 for aln_termination root"  do

  before(:each) do
    root = AlnTermination.new(model_data[:aln_termination])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.first << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.first.supported.last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.supported.last.supported.last << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.save_hierarchy
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:each) do
    @root.destroy
  end

#  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is greater than 1"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 1 for aln_resource root"  do
  
  before(:each) do
    root = AlnResource.new(model_data[:aln_resource])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.save_hierarchy
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end
  
  after(:each) do
    @root.destroy
  end

#  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 1"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 1 for aln_termination root"  do

  before(:each) do
    root = AlnTermination.new(model_data[:aln_termination])
    root << [AlnTermination.new(model_data[:aln_termination_supported_1]), AlnTermination.new(model_data[:aln_termination_supported_2]),
             AlnResource.new(model_data[:aln_resource_supported_1]), AlnResource.new(model_data[:aln_resource_supported_2])]
    root.save_hierarchy
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:each) do
    @root.destroy
  end

#  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 1"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 0 for aln_resource root"  do
  
  before(:each) do
    root = AlnResource.new(model_data[:aln_resource])
    root.save_hierarchy
    @root = AlnResource.find_support_root_by_model(AlnResource, :first)
  end
  
  after(:each) do
    @root.destroy
  end

#  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 0"
  
end

##########################################################################################################
describe "queries for supported within hierachy from hierarchy root when hiearchy depth is 0 for aln_termination root"  do

  before(:each) do
    root = AlnTermination.new(model_data[:aln_termination])
    root.save_hierarchy
    @root = AlnTermination.find_support_root_by_model(AlnTermination, :first)
  end

  after(:each) do
    @root.destroy
  end

#  it_should_behave_like "queries for supported within hierachy from hierarchy root when hiearchy depth is 0"
  
end
