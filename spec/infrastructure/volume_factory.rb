class VolumeFactory
  class << self
    def no_volumes_defined
      { 
        "volumeSet"=>nil, 
        "requestId"=>"8c45bb4a-3018-496a-931c-c4136b55ce56", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
    def one_volume_defined
      {
        "volumeSet" => {
          "item"=> [
            {
              "attachmentSet"=>nil, 
              "createTime"=>"2009-09-23T01:43:10.000Z", 
              "size"=>"1", 
              "volumeId"=>"vol-1ba05372", 
              "snapshotId"=>nil, 
              "status"=>"available", 
              "availabilityZone"=>"us-east-1a"
            }
          ]
        }, 
        "requestId"=>"0806e66f-35d8-4a7c-a88d-2ff6bea6696d", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
    def multiple_volumes_defined
      {
        "volumeSet" => {
          "item" => [
            {
              "attachmentSet"=>nil, 
              "createTime"=>"2009-09-23T01:43:10.000Z", 
              "size"=>"1", 
              "volumeId"=>"vol-1ba05372", 
              "snapshotId"=>nil, 
              "status"=>"deleting", 
              "availabilityZone"=>"us-east-1a"
            }, 
            {
              "attachmentSet"=>nil, 
              "createTime"=>"2009-09-23T02:03:05.000Z", 
              "size"=>"1", 
              "volumeId"=>"vol-b0a053d9", 
              "snapshotId"=>nil, 
              "status"=>"available", 
              "availabilityZone"=>"us-east-1a"
            }
          ]
        }, 
        "requestId"=>"b8597549-5d8d-47f3-a199-cdd85a549c49", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
    def create_volume_response
      {
        "createTime"=>"2009-09-23T01:43:10.000Z", 
        "size"=>"1", 
        "volumeId"=>"vol-1ba05372", 
        "snapshotId"=>nil, 
        "requestId"=>"f9ce03c7-df66-4028-8c73-9c3ba7c42af6", 
        "status"=>"creating", 
        "availabilityZone"=>"us-east-1a", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
    def attaching_response
      {
        "device"=>"/dev/sdk", 
        "volumeId"=>"vol-1ba05372", 
        "requestId"=>"5ed1aa42-7cd3-4510-b227-34854ed905f5", 
        "instanceId"=>"i-17c3147f", 
        "attachTime"=>"2009-09-23T01:52:17.000Z", 
        "status"=>"attaching", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
    def attached_response
      {
        "volumeSet" => {
          "item" => [
            {
              "attachmentSet" => {
                "item" => [
                  {
                    "device"=>"/dev/sdk", 
                    "volumeId"=>"vol-1ba05372", 
                    "instanceId"=>"i-17c3147f", 
                    "attachTime"=>"2009-09-23T01:52:17.000Z", 
                    "status"=>"attached"
                  }
                ]
              }, 
              "createTime"=>"2009-09-23T01:43:10.000Z", 
              "size"=>"1", 
              "volumeId"=>"vol-1ba05372", 
              "snapshotId"=>nil, 
              "status"=>"in-use", 
              "availabilityZone"=>"us-east-1a"
            }
          ]
        }, 
        "requestId"=>"cac56985-033e-4174-902e-3d2f72607430", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
    def detatching_response
      {
        "device"=>"/dev/sdk", 
        "volumeId"=>"vol-1ba05372", 
        "requestId"=>"da51cad5-b081-47d1-9b40-9e8b47a4286d", 
        "instanceId"=>"i-17c3147f", 
        "attachTime"=>"2009-09-23T01:52:17.000Z", 
        "status"=>"detaching", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end

    def delete_volume_response
      {
        "requestId"=>"a84c778e-d930-4ffe-a021-09af15c248c6", 
        "return"=>"true", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
    def deleting_response
      {
        "volumeSet" => {
          "item" => [
            {
              "attachmentSet"=>nil, 
              "createTime"=>"2009-09-23T01:43:10.000Z", 
              "size"=>"1", 
              "volumeId"=>"vol-1ba05372", 
              "snapshotId"=>nil, 
              "status"=>"deleting", 
              "availabilityZone"=>"us-east-1a"
            }
          ]
        }, 
        "requestId"=>"68888c18-8d86-4a30-a1fc-a65be4883785", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
  end
end