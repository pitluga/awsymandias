require File.expand_path(File.dirname(__FILE__) + "/unit_spec_helper")

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

  describe "wait_for" do
    it "should not sleep if the block returns true" do
      Awsymandias.should_receive(:sleep).never
      Awsymandias.wait_for("message", 5) { true }
    end
    
    it "should sleep for the specified number of seconds until the block returns true" do
      responses = [true, false, false]
      Awsymandias.stub!(:sleep)
      Awsymandias.should_receive(:sleep).twice.with(10)
      Awsymandias.wait_for("message", 10) { responses.pop }
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
