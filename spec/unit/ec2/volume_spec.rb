require File.expand_path(File.dirname(__FILE__) + "/../unit_spec_helper")

describe Volume = Awsymandias::EC2::Volume do

  context "find" do
    it "return empty array if no volumes are defined" do
      Awsymandias::EC2.connection.should_receive(:describe_volumes).and_return(VolumeFactory.no_volumes_defined)
      Volume.find.should == []
    end
    
    it "should pass any ids passed as volume_ids" do
      Awsymandias::EC2.connection.should_receive(:describe_volumes).
        with(:volume_ids => ["vol-b0a053d9", "vol-1ba05372"]).
        and_return(VolumeFactory.multiple_volumes_defined)
      
      Volume.find "vol-b0a053d9", "vol-1ba05372"
    end
    
    it "should correctly populate the volume object" do
      Awsymandias::EC2.connection.stub!(:describe_volumes).and_return(VolumeFactory.attached_response)
      volumes = Volume.find
      volume = volumes.first
      
      volume.id.should == 'vol-1ba05372'
      volume.size.should == '1'
      volume.status.should == 'in-use'
      volume.availability_zone.should == 'us-east-1a'
      volume.create_time.should == '2009-09-23T01:43:10.000Z'
      volume.device.should == '/dev/sdk'
      volume.instance_id.should == 'i-17c3147f'
    end
    
    it "should correctly populate an unattached volume" do
      Awsymandias::EC2.connection.stub!(:describe_volumes).and_return(VolumeFactory.one_volume_defined)
      volumes = Volume.find
      volume = volumes.first
      
      volume.device.should be_nil
      volume.instance_id.should be_nil
    end
    
    it "should populate multiple volumes" do
      Awsymandias::EC2.connection.stub!(:describe_volumes).and_return(VolumeFactory.multiple_volumes_defined)
      volumes = Volume.find

      volumes.size.should == 2
    end
  end

end