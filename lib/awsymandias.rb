Dir[File.dirname(__FILE__) + "/../vendor/**/lib"].each { |dir| $: << dir }

require 'EC2'
require 'aws_sdb'
require 'money'
require 'activesupport'
require 'activeresource'
require 'net/telnet'

require File.dirname(__FILE__) + '/awsymandias/support/hash'
require File.dirname(__FILE__) + '/awsymandias/support/class_extension'
require File.dirname(__FILE__) + '/awsymandias/simple_db'
require File.dirname(__FILE__) + '/awsymandias/ec2/ec2_resource'
require File.dirname(__FILE__) + '/awsymandias/ec2/instance'
require File.dirname(__FILE__) + '/awsymandias/ec2/volume'
require File.dirname(__FILE__) + '/awsymandias/ec2/application_stack'

module Awsymandias
  class << self
    attr_writer :access_key_id, :secret_access_key
    attr_accessor :verbose
  
    Awsymandias.verbose = false
    
    def access_key_id
      @access_key_id || ENV['AMAZON_ACCESS_KEY_ID']
    end
    
    def secret_access_key
      @secret_access_key || ENV['AMAZON_SECRET_ACCESS_KEY']
    end
    
    def wait_for(message, refresh_seconds, &block)
      print "Waiting for #{message}.." if Awsymandias.verbose
      while !block.call
        print "." if Awsymandias.verbose
        sleep(refresh_seconds)      
      end
      verbose_output "OK!"
    end
    
    def verbose_output(message)
      puts message if Awsymandias.verbose
    end
    
  end
  
  module EC2
    class << self
      # Define the values for AMAZON_ACCESS_KEY_ID and AMAZON_SECRET_ACCESS_KEY_ID to allow for automatic
      # connection creation.
      def connection
        @connection ||= ::EC2::Base.new(
          :access_key_id     => Awsymandias.access_key_id     || ENV['AMAZON_ACCESS_KEY_ID'],
          :secret_access_key => Awsymandias.secret_access_key || ENV['AMAZON_SECRET_ACCESS_KEY']
        )
      end
      
      def instance_types
        [ 
          Awsymandias::EC2::InstanceTypes::M1_SMALL, 
          Awsymandias::EC2::InstanceTypes::M1_LARGE, 
          Awsymandias::EC2::InstanceTypes::M1_XLARGE, 
          Awsymandias::EC2::InstanceTypes::C1_MEDIUM, 
          Awsymandias::EC2::InstanceTypes::C1_XLARGE 
        ].index_by(&:name)
      end
    end
    
    InstanceType = Struct.new(:name, :price_per_hour)
    
    # All currently available instance types.
    # TODO Generate dynamically.
    module InstanceTypes
      M1_SMALL  = InstanceType.new("m1.small",  Money.new(10))
      M1_LARGE  = InstanceType.new("m1.large",  Money.new(40))
      M1_XLARGE = InstanceType.new("m1.xlarge", Money.new(80))

      C1_MEDIUM = InstanceType.new("c1.medium", Money.new(20))
      C1_XLARGE = InstanceType.new("c1.xlarge", Money.new(80))
    end
        
    # All currently availability zones.
    # TODO Generate dynamically.
    module AvailabilityZones
      US_EAST_1A = "us_east_1a"
      US_EAST_1B = "us_east_1b"
      US_EAST_1C = "us_east_1c"

      EU_WEST_1A = "eu_west_1a"
      EU_WEST_1B = "eu_west_1b"
    end
  
  end
end
