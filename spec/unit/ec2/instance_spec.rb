require File.expand_path(File.dirname(__FILE__) + "/../unit_spec_helper")

describe Instance = Awsymandias::EC2::Instance do

  def stub_connection_with(return_value)
    Awsymandias::EC2.stub!(:connection).and_return stub("a connection", :describe_instances => return_value)
  end
  
  describe "find" do
    it "should raise ActiveResource::ResourceNotFound if the given instance ID is not found" do
      stub_connection_with InstanceFactory.describe_instances_no_results_xml
      lambda do
        Instance.find("i-some-instance")
      end.should raise_error(ActiveResource::ResourceNotFound)
    end

    it "should return an object with the appropriate instance ID when an instance with the given ID is found" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      Instance.find("i-some-instance").instance_id.should == "i-some-instance"
    end

    it "should return more than one object if multiple IDs are requested" do
      stub_connection_with InstanceFactory.describe_instances_multiple_results_running_xml
      Instance.find(:all, :instance_ids => ["i-some-other-instance", "i-some-instance", "i-another-instance"]).map do |instance|
        instance.instance_id
      end.should == ["i-some-other-instance", "i-some-instance", "i-another-instance"]
    end

    it "should map camelized XML properties to Ruby-friendly underscored method names" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Instance.find("i-some-instance")
      instance.image_id.should == "ami-some-image"
      instance.key_name.should == "gsg-keypair"
      instance.instance_type.should == Awsymandias::EC2.instance_types["m1.large"]
      instance.placement.availability_zone.should == "us-east-1c"
    end
  end

  describe "to_params" do
    it "should be able to reproduce a reasonable set of its launch params as a hash" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      Instance.find("i-some-instance").to_params.should == {
        :image_id => "ami-some-image",
        :key_name => "gsg-keypair",
        :instance_type => Awsymandias::EC2.instance_types["m1.large"],
        :availability_zone => "us-east-1c"
      }
    end
  end

  describe "running?" do        
    it "should return false if it contains an instances set with the given instance ID and its state is pending" do
      stub_connection_with InstanceFactory.describe_instances_single_result_pending_xml
      Instance.find("i-some-instance").should_not be_running
    end

    it "should return true if it contains an instances set with the given instance ID and its state is running" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      Instance.find("i-some-instance").should be_running
    end
  end

  describe "reload" do
    it "should reload an instance without replacing the object" do
      stub_connection_with InstanceFactory.describe_instances_single_result_pending_xml
      instance = Instance.find("i-some-instance")
      instance.should_not be_running

      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance.reload.should be_running
    end    
  end

  describe "launch" do
    it "should launch a new instance given some values" do
      mock_connection = mock("a connection")
      mock_connection.should_receive(:run_instances).with(hash_including(
        :image_id => "an_id",
        :key_name => "gsg-keypair",
        :instance_type => "m1.small",
        :availability_zone => Awsymandias::EC2::AvailabilityZones::US_EAST_1A
      )).and_return(InstanceFactory.run_instances_single_result_xml)

      mock_connection.should_receive(:describe_instances).and_return(InstanceFactory.describe_instances_single_result_pending_xml)

      Awsymandias::EC2.stub!(:connection).and_return mock_connection

      Awsymandias::EC2::Instance.launch(
        :image_id => "an_id",
        :key_name => "gsg-keypair",
        :instance_type => Awsymandias::EC2::InstanceTypes::M1_SMALL,
        :availability_zone => Awsymandias::EC2::AvailabilityZones::US_EAST_1A        
      ).instance_id.should == "i-some-instance"
    end

    it "should convert the instance type it's given to a string as needed" do
      mock_connection = mock("a connection")
      mock_connection.should_receive(:run_instances).with(hash_including(
        :instance_type => "m1.small"
      )).and_return(InstanceFactory.run_instances_single_result_xml)
      mock_connection.should_receive(:describe_instances).and_return(stub("response").as_null_object)
      Awsymandias::EC2.stub!(:connection).and_return mock_connection

      Awsymandias::EC2::Instance.launch(:instance_type => Awsymandias::EC2::InstanceTypes::M1_SMALL)
    end
  end

  describe "terminate!" do
    it "should terminate a running instance" do
      mock_connection = mock("a connection")
      mock_connection.should_receive(:describe_instances).and_return(
        InstanceFactory.describe_instances_single_result_running_xml,
        InstanceFactory.describe_instances_single_result_terminated_xml
      )
      mock_connection.should_receive(:terminate_instances).and_return(
        InstanceFactory.terminate_instances_single_result_xml
      )

      Awsymandias::EC2.stub!(:connection).and_return mock_connection

      instance = Awsymandias::EC2::Instance.find("a result id")
      instance.should be_running
      instance.terminate!
      instance.should_not be_running
      instance.should be_terminated
    end
  end

  describe "instance_type" do
    it "should return its instance_type attribute as an InstanceType object" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      Instance.find("i-some-instance").instance_type.should == Awsymandias::EC2::InstanceTypes::M1_LARGE
    end
  end

  describe "launch_time" do
    it "should return its launch_time attribute as an instance of Time" do
      stub_connection_with InstanceFactory.describe_instances_single_result_pending_xml
      Awsymandias::EC2::Instance.find("i-some-instance").launch_time.should == Time.parse("2009-04-20T01:30:35.000Z")
    end
  end

  describe "uptime" do
    it "should be zero seconds if it is not yet running" do
      stub_connection_with InstanceFactory.describe_instances_single_result_pending_xml
      Awsymandias::EC2::Instance.find("i-some-instance").uptime.should == 0.seconds
    end

    it "should calculate the uptime of a running instance in terms of its launch time" do
      time_now = Time.now
      Time.stub!(:now).and_return time_now
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Awsymandias::EC2::Instance.find("i-some-instance")
      instance.uptime.should == (time_now - instance.launch_time)
    end
  end

  describe "public_dns" do
    it "should return the public dns from the xml" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml 
      Awsymandias::EC2::Instance.find("i-some-instance").public_dns.should == "ec2-174-129-118-52.compute-1.amazonaws.com"
    end
  end

  describe "private_dns" do
    it "should return the private dns from the xml" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml 
      Awsymandias::EC2::Instance.find("i-some-instance").private_dns.should == "ip-10-244-226-239.ec2.internal"
    end
  end

  describe "running_cost" do
    it "should be zero if the instance has not yet been launched" do
      stub_connection_with InstanceFactory.describe_instances_single_result_pending_xml
      Awsymandias::EC2::Instance.find("i-some-instance").running_cost.should == Money.new(0)
    end

    it "should be a single increment if the instance was launched 5 minutes ago" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Awsymandias::EC2::Instance.find("i-some-instance")
      instance.instance_variable_set :@launch_time, 5.minutes.ago
      expected_cost = instance.instance_type.price_per_hour
      instance.running_cost.should == expected_cost
    end

    it "should be a single increment if the instance was launched 59 minutes ago" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Awsymandias::EC2::Instance.find("i-some-instance")
      instance.instance_variable_set :@launch_time, 59.minutes.ago
      expected_cost = instance.instance_type.price_per_hour
      instance.running_cost.should == expected_cost
    end

    it "should be two increments if the instance was launched 61 minutes ago" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Awsymandias::EC2::Instance.find("i-some-instance")
      instance.instance_variable_set :@launch_time, 61.minutes.ago
      expected_cost = instance.instance_type.price_per_hour * 2
      instance.running_cost.should == expected_cost          
    end

    it "should be three increments if the instance was launched 150 minutes ago" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Awsymandias::EC2::Instance.find("i-some-instance")
      instance.instance_variable_set :@launch_time, 150.minutes.ago
      expected_cost = instance.instance_type.price_per_hour * 3
      instance.running_cost.should == expected_cost          
    end
  end

  describe "port_open?" do
    it "should return true if telnet does not raise" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Awsymandias::EC2::Instance.find("i-some-instance")
      Net::Telnet.should_receive(:new).with("Host" => "ec2-174-129-118-52.compute-1.amazonaws.com",
                                            "Port" => 100,
                                            "Timeout" => 5).and_return(true)
      instance.port_open?(100).should be_true
    end

    it "should return false if telnet does raise" do
      stub_connection_with InstanceFactory.describe_instances_single_result_running_xml
      instance = Awsymandias::EC2::Instance.find("i-some-instance")
      Net::Telnet.should_receive(:new).with("Host" => "ec2-174-129-118-52.compute-1.amazonaws.com",
                                            "Port" => 100,
                                            "Timeout" => 5).and_raise(Timeout::Error)
      instance.port_open?(100).should be_false
    end
  end
end

