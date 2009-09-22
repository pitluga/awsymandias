class InstanceFactory
  class << self
    
    def describe_instances_no_results_xml
      {
        "requestId" => "7bca5c7c-1b51-473e-a930-611e55920e39",
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/",
        "reservationSet" => nil
      }
    end

    def describe_instances_single_result_pending_xml
      {
        "requestId" => "7bca5c7c-1b51-473e-a930-611e55920e39",
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/",
        "reservationSet" => {
          "item" => [ 
            {
              "reservationId" => "r-db68e3b2", 
              "requesterId" => "058890971305", 
              "ownerId" => "358110980006",
              "groupSet" => { 
                "item" => [ { "groupId" => "default" } ] 
              }, 
              "instancesSet" => { 
                "item" => [ 
                  { 
                    "productCodes" => nil, 
                    "kernelId" => "aki-some-kernel", 
                    "amiLaunchIndex" => "0", 
                    "keyName" => "gsg-keypair", 
                    "ramdiskId" => "ari-b31cf9da", 
                    "launchTime" => "2009-04-20T01:30:35.000Z", 
                    "instanceType" => "m1.large", 
                    "imageId" => "ami-some-image", 
                    "privateDnsName" => nil, 
                    "reason" => nil, 
                    "placement" => { 
                      "availabilityZone" => "us-east-1c" 
                    }, 
                    "dnsName" => nil, 
                    "instanceId" => "i-some-instance", 
                    "instanceState" => {
                      "name" => "pending", 
                      "code"=>"0" 
                    } 
                  } 
                ] 
              } 
            } 
          ]
        } 
      }
    end
    
    def describe_instances_single_result_running_xml
      {
        "requestId" => "7bca5c7c-1b51-473e-a930-611e55920e39",
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/",
        "reservationSet" => {
          "item" => [ 
            {
              "reservationId" => "r-db68e3b2", 
              "requesterId" => "058890971305", 
              "ownerId" => "358110980006",
              "groupSet" => { "item" => [ { "groupId" => "default" } ] }, 
              "instancesSet" => { 
                "item" => [ 
                  { 
                    "productCodes" => nil, 
                    "kernelId" => "aki-some-kernel", 
                    "amiLaunchIndex" => "0", 
                    "keyName" => "gsg-keypair", 
                    "ramdiskId" => "ari-b31cf9da", 
                    "launchTime" => "2009-04-20T01:30:35.000Z", 
                    "instanceType" => "m1.large", 
                    "imageId" => "ami-some-image", 
                    "privateDnsName" => "ip-10-244-226-239.ec2.internal", 
                    "reason" => nil, 
                    "placement" => { 
                      "availabilityZone" => "us-east-1c" 
                    }, 
                    "dnsName" => "ec2-174-129-118-52.compute-1.amazonaws.com", 
                    "instanceId" => "i-some-instance", 
                    "instanceState" => {
                      "name" => "running", 
                      "code"=>"0" 
                    } 
                  } 
                ] 
              } 
            } 
          ] 
        } 
      }
    end

    def describe_instances_multiple_results_running_xml
      {
        "requestId" => "7bca5c7c-1b51-473e-a930-611e55920e39",
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/",
        "reservationSet" => {
          "item" => [ 
            { 
              "reservationId"=>"r-5b226e32",
              "ownerId"=>"423319072129",
              "groupSet" => { "item" => [ {"groupId"=>"default" } ] },
              "instancesSet" => { 
                "item" => [
                  { 
                    "productCodes"=>nil,
                    "kernelId"=>"aki-some-kernel",
                    "amiLaunchIndex"=>"0",
                    "ramdiskId"=>"ari-b31cf9da",
                    "launchTime"=>"2009-07-14T17:47:33.000Z",
                    "instanceType"=>"c1.xlarge",
                    "imageId"=>"ami-some-other-image",
                    "privateDnsName"=>nil,
                    "reason"=>nil,
                    "placement" => {
                      "availabilityZone"=>"us-east-1b"
                    },
                    "dnsName" => nil,
                    "instanceId"=>"i-some-other-instance",
                    "instanceState" => { 
                      "name"=>"running", 
                      "code"=>"16",
                    }
                  }
                ] 
              } 
            },
            { 
              "reservationId" => "r-db68e3b2", 
              "requesterId" => "058890971305", 
              "ownerId" => "358110980006",
              "groupSet" => { "item" => [ { "groupId" => "default" } ] }, 
              "instancesSet" => { 
                "item" => [ 
                  { 
                    "productCodes" => nil, 
                    "kernelId" => "aki-some-kernel", 
                    "amiLaunchIndex" => "0", 
                    "keyName" => "gsg-keypair", 
                    "ramdiskId" => "ari-b31cf9da", 
                    "launchTime" => "2009-04-20T01:30:35.000Z", 
                    "instanceType" => "m1.large", 
                    "imageId" => "ami-some-image", 
                    "privateDnsName" => nil, 
                    "reason" => nil, 
                    "placement" => { 
                      "availabilityZone" => "us-east-1c" 
                    }, 
                    "dnsName" => nil, 
                    "instanceId" => "i-some-instance", 
                    "instanceState" => {
                      "name" => "running", 
                      "code"=>"0" 
                    } 
                  },
                  { 
                    "productCodes" => nil, 
                    "kernelId" => "aki-some-kernel", 
                    "amiLaunchIndex" => "0", 
                    "keyName" => "gsg-keypair", 
                    "ramdiskId" => "ari-b31cf9da", 
                    "launchTime" => "2009-04-20T01:30:35.000Z", 
                    "instanceType" => "m1.large", 
                    "imageId" => "ami-some-image", 
                    "privateDnsName" => nil, 
                    "reason" => nil, 
                    "placement" => { 
                      "availabilityZone" => "us-east-1c" 
                    }, 
                    "dnsName" => nil, 
                    "instanceId" => "i-another-instance", 
                    "instanceState" => {
                      "name" => "pending", 
                      "code"=>"0" 
                    } 
                  } 
                ] 
              } 
            }
          ]
        } 
      }
    end
    
    def run_instances_single_result_xml
      {
        "reservationId" => "r-276ee54e", 
        "groupSet" => { "item" => [ { "groupId" => "default" } ] }, 
        "requestId" => "a29db909-d8ef-4a14-80c1-c53157c0cd49", 
        "instancesSet" => { 
          "item" => [ 
            { 
              "kernelId" => "aki-some-kernel", 
              "amiLaunchIndex" => "0", 
              "keyName" => "gsg-keypair", 
              "ramdiskId" => "ari-b31cf9da", 
              "launchTime" => "2009-04-20T01:39:12.000Z", 
              "instanceType" => "m1.large", 
              "imageId" => "ami-some-image", 
              "privateDnsName" => nil, 
              "reason" => nil, 
              "placement" => { 
                "availabilityZone" => "us-east-1a"
              }, 
              "dnsName" => nil, 
              "instanceId" => "i-some-instance", 
              "instanceState" => { 
                "name" => "pending", 
                "code" => "0" 
              } 
            } 
          ] 
        }, 
        "ownerId"=>"358110980006", 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end

    def terminate_instances_single_result_xml
      {
        "requestId" => "c80c4770-eaab-45ce-972d-10e928e3f80c", 
        "instancesSet" => {
          "item" => [ 
            { 
              "previousState" => { 
                "name" => "running", 
                "code"=>"16"
                }, 
                "shutdownState" => { 
                  "name" => "shutting-down", 
                  "code" => "32"
                }, 
                "instanceId" => "i-some-instance" 
              } 
            ] 
          }, 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
  
    def describe_instances_single_result_terminated_xml
     {
       "requestId" => "8b4fb505-de40-41b2-b18e-58f9bcba6f09", 
       "reservationSet" => { 
         "item" => [ 
           { 
             "reservationId" => "r-75961c1c", 
             "groupSet" => { "item" => [ { "groupId" => "default" } ] }, 
             "instancesSet" => {
               "item" => [
                 { 
                   "productCodes" => nil, 
                   "kernelId" => "aki-some-kernel", 
                   "amiLaunchIndex" => "0", 
                   "keyName" => "gsg-keypair", 
                   "ramdiskId" => "ari-b31cf9da", 
                   "launchTime" => "2009-04-22T00:54:06.000Z", 
                   "instanceType" => "c1.xlarge", 
                   "imageId" => "ami-some-image", 
                   "privateDnsName" => nil, 
                   "reason" => "User initiated (2009-04-22 00:59:53 GMT)", 
                   "placement" => { 
                     "availabilityZone" => nil
                   }, 
                   "dnsName" => nil, 
                   "instanceId" => "i-some-instance", 
                   "instanceState" => { 
                     "name" => "terminated", 
                     "code" => "48"
                   } 
                 } 
               ]
             }, 
             "ownerId" => "358110980006" 
            } 
          ] 
        }, 
        "xmlns"=>"http://ec2.amazonaws.com/doc/2008-12-01/"
      }
    end
    
  end
end