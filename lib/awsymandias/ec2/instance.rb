# An instance represents an AWS instance as derived from a call to EC2's describe-instances methods.
# It wraps the simple hash structures returned by the EC2 gem with a domain model.
# It inherits from ARes::B in order to provide simple XML <-> domain model mapping.
module Awsymandias
  module EC2
    class Instance < EC2Resource
      attributes :instance_id, :instance_state, :image_id, :placement, :key_name
      complex_attribute :private_dns, lambda { |hash| hash['private_dns_name'] }
      complex_attribute :public_dns, lambda { |hash| hash['dns_name'] }
      complex_attribute :launch_time, lambda { |hash| Time.parse(hash['launch_time']) }
      complex_attribute :instance_type, lambda { |hash| Awsymandias::EC2.instance_types[hash['instance_type']] }

      alias :id :instance_id

      def pending?
        instance_state.name == "pending"
      end

      def running?
        instance_state.name == "running"
      end

      def port_open?(port)
        Net::Telnet.new("Host" => public_dns, "Port" => port, "Timeout" => 5) 
        true
      rescue Timeout::Error, Errno::ECONNREFUSED
        false
      end
      
      def terminated?
        instance_state.name == "terminated"
      end

      def terminate!
        Awsymandias::EC2.connection.terminate_instances :instance_id => self.instance_id
        reload
      end

      def reload
        response = EC2.connection.describe_instances(:instance_id => [ self.instance_id ])
        instance_data = response["reservationSet"]["item"].first["instancesSet"]["item"].first
        load(reformat_incoming_param_data(instance_data))
      end        

      def to_params
        {
          :image_id => self.image_id,
          :key_name => self.key_name,
          :instance_type => self.instance_type,
          :availability_zone => self.placement.availability_zone
        }
      end

      def uptime
        return 0.seconds if pending?
        Time.now - self.launch_time
      end

      def running_cost
        return Money.new(0) if pending?
        instance_type.price_per_hour * (uptime / 1.hour).ceil 
      end

      class << self
        def find(*args)
          opts = args.extract_options!
          what = args.first

          if what == :all
            find_all(opts[:instance_ids], opts)
          else
            find_one(what, opts)
          end
        end

        def find_all(ids, opts={})
          reservation_set = EC2.connection.describe_instances(:instance_id => ids)["reservationSet"]
          if reservation_set.nil?
            []
          else
            reservation_set["item"].sum([]) do |item_set|
              item_set["instancesSet"]["item"].map do |item|
                self.build_from_service(reformat_incoming_param_data(item))
              end
            end
          end
        end

        def find_one(id, opts={})
          reservation_set = EC2.connection.describe_instances(:instance_id => [ id ])["reservationSet"]
          if reservation_set.nil?
            raise ActiveResource::ResourceNotFound, "not found: #{id}"
          else
            reservation_set["item"].first["instancesSet"]["item"].map do |item|
              self.build_from_service(reformat_incoming_param_data(item))
            end.first
          end
        end

        def launch(opts={})
          opts.assert_valid_keys! :image_id, :key_name, :instance_type, :availability_zone, :user_data

          opts[:instance_type] = opts[:instance_type].name if opts[:instance_type].is_a?(Awsymandias::EC2::InstanceType)

          response = Awsymandias::EC2.connection.run_instances opts
          instance_id = response["instancesSet"]["item"].map {|h| h["instanceId"]}.first
          find(instance_id)
        end
      end
    end
  end
end
