require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/awsymandias")

describe Awsymandias do
  describe Awsymandias::SimpleDB do
    describe "connection" do
      it "configure an instance of AwsSdb::Service" do
        Awsymandias.access_key_id = "configured key"
        Awsymandias.secret_access_key = "configured secret"
      
        ::AwsSdb::Service.should_receive(:new).
          with(hash_including(:access_key_id => "configured key", :secret_access_key => "configured secret")).
          and_return(:a_connection)
      
        Awsymandias::SimpleDB.connection.should == :a_connection
      end
    end
  end
  
  describe Awsymandias::EC2 do    
    def zero_dollars
      Money.new(0)
    end
    
    describe "connection" do
      it "should configure an instance of EC2::Base" do
        Awsymandias.access_key_id = "configured key"
        Awsymandias.secret_access_key = "configured secret"

        ::EC2::Base.should_receive(:new).
          with(hash_including(:access_key_id => "configured key", :secret_access_key => "configured secret")).
          and_return(:a_connection)

        Awsymandias::EC2.connection.should == :a_connection
      end    
    end
    
  end
end
