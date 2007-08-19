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
    root = AlnConnection.new(model_data[:aln_connection_1])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root << AlnResource.new(model_data[:aln_resource_supported_2])
    root.save
    root_chk = AlnResource.find_support_root_by_model(AlnResource, :all)
    root_chk.length.should be(3)
    root_chk.each do |r|
      r.name.should eql(model_data[:aln_termination]['name']) if r.descendant.class.eql?(AlnTermination)
      r.name.should eql(model_data[:aln_connection_1]['name']) if r.descendant.class.eql?(AlnConnection)
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
    root_con = AlnConnection.new(model_data[:aln_connection_1])
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

