require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/awsymandias")

describe 'a launched instance' do
  
  before :all do
    Awsymandias.access_key_id = ENV['AMAZON_ACCESS_KEY_ID'] 
    Awsymandias.secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
    
    @stack = Awsymandias::EC2::ApplicationStack.new('instances') do |s|
      s.instance :box,  :image_id => 'ami-20b65349'
    end
    
    @stack.launch
    Awsymandias.wait_for('stack to start', 5) { @stack.reload.running? }
  end
  
  after :all do
    @stack.terminate!
  end
  
  it "should show the stack as running" do
    @stack.running?.should be_true
  end

  it "instances:  should be available through a method on stack" do
    @stack.box.should_not be_nil
  end

  it "instances:  should show as running" do
    @stack.box.running?.should be_true
  end
  
end