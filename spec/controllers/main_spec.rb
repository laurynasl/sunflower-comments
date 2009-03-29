require File.dirname(__FILE__) + '/../spec_helper'

describe "SunflowerComments::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:SunflowerComments) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(SunflowerComments::Main, :index)
    controller.slice.should == SunflowerComments
    controller.slice.should == SunflowerComments::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(SunflowerComments::Main, :index)
    controller.status.should == 200
    controller.body.should contain('SunflowerComments')
  end
  
  it "should work with the default route" do
    controller = get("/sunflower-comments/main/index")
    controller.should be_kind_of(SunflowerComments::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/sunflower-comments/index.html")
    controller.should be_kind_of(SunflowerComments::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(SunflowerComments::Main, 'index')
    
    url = controller.url(:sunflower_comments_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/sunflower-comments/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:sunflower_comments_index, :format => 'html')
    url.should == "/sunflower-comments/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:sunflower_comments_home)
    url.should == "/sunflower-comments/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(SunflowerComments::Main, :index)
    controller.public_path_for(:image).should == "/slices/sunflower-comments/images"
    controller.public_path_for(:javascript).should == "/slices/sunflower-comments/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/sunflower-comments/stylesheets"
    
    controller.image_path.should == "/slices/sunflower-comments/images"
    controller.javascript_path.should == "/slices/sunflower-comments/javascripts"
    controller.stylesheet_path.should == "/slices/sunflower-comments/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    SunflowerComments::Main._template_root.should == SunflowerComments.dir_for(:view)
    SunflowerComments::Main._template_root.should == SunflowerComments::Application._template_root
  end

end