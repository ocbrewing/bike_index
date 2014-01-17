require 'spec_helper'

describe ComponentCreator do

  describe :set_manufacturer_key do
    it "should set the manufacturer if it finds it and set the set the foreign keys" do
      m = FactoryGirl.create(:manufacturer, name: "SRAM")
      c = { manufacturer: "sram" }
      component = ComponentCreator.new().set_manufacturer_key(c)
      component[:manufacturer_id].should eq(m.id)
      component[:manufacturer].should_not be_present
    end
    it "should add other manufacturer name and set the set the foreign keys" do
      m = FactoryGirl.create(:manufacturer, name: "Other")
      c = { manufacturer: "Gobbledy Gooky" }
      component = ComponentCreator.new().set_manufacturer_key(c)
      component[:manufacturer_id].should eq(m.id)
      component[:manufacturer].should_not be_present
      component[:manufacturer_other].should eq('Gobbledy Gooky')
    end
  end

  describe :set_component_type do 
    it "should set the component_type from a slug" do 
      ctype = FactoryGirl.create(:ctype, name: "Stuff")
      c = { component_type: "sTuff " }
      component = ComponentCreator.new().set_component_type(c)
      component[:ctype_id].should eq(ctype.id)
      component[:component_type].should_not be_present
    end
  end

  describe :set_duplicate do 
    it "should return an array even if front_or_rear isn't there" do 
      ctype = FactoryGirl.create(:ctype, name: "Stuff")
      c = { year: 999 }
      components = ComponentCreator.new().set_duplicate(c)
      components[0][:year].should eq(999)
    end
    it "should create a second component if front_or_rear is both" do 
      ctype = FactoryGirl.create(:ctype, name: "Stuff")
      c = { front_or_rear: "Both" }
      components = ComponentCreator.new().set_duplicate(c)
      components[0][:front].should be_true
      components[1][:rear].should be_true
    end
  end

  describe :create_component do 
    it "should create the component" do 
      bike = FactoryGirl.create(:bike)
      components = [{description: "Stuff"}]
      component_creator = ComponentCreator.new(bike: bike)
      component_creator.should_receive(:set_duplicate).and_return(components)
      component_creator.create_component("empty")
      bike.components.count.should eq(1)
    end
  end

  describe :create_components_from_params do 
    it "should return nil if there are no components" do 
      b_param = BParam.new
      b_param.stub(:params).and_return({s: "things"})
      component_creator = ComponentCreator.new(b_param: b_param)
      component_creator.create_components_from_params.should be_nil
    end
    it "should call the necessary methods to create a component on each component" do 
      b_param = BParam.new 
      components = [{component_type: "something"}, {component_type: "something"}]
      b_param.stub(:params).and_return(components: components)
      component_creator = ComponentCreator.new(b_param: b_param)
      component_creator.should_receive(:set_manufacturer_key).at_least(2).times.and_return(true)
      component_creator.should_receive(:set_component_type).at_least(2).times.and_return(true)
      component_creator.should_receive(:create_component).at_least(2).times.and_return(true)
      component_creator.create_components_from_params
    end
    # it "should do everything test" do 
    #   bike = FactoryGirl.create(:bike)
    #   ctype = FactoryGirl.create(:ctype)
    #   b_param = BParam.new 
    #   components = [
    #     {component_type: ctype.slug, year: "1999"},
    #     {component_type: ctype.slug, front_or_rear: "both"}]
    #   b_param.stub(:params).and_return(components: components)
    #   component_creator = ComponentCreator.new(b_param: b_param, bike: bike)
    #   component_creator.create_components_from_params
    #   bike.components.count.should eq(3)
    # end
  end

end