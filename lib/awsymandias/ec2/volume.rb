module Awsymandias
  module EC2
    class Volume < EC2Resource
      attributes :size, :status, :availability_zone, :create_time, :device
      complex_attribute :id, lambda { |hash| hash['volume_id'] }
      complex_attribute :device, lambda { |hash| nilsafe { hash['attachment_set']['item'].first['device'] } }
      complex_attribute :instance_id, lambda { |hash| nilsafe { hash['attachment_set']['item'].first['instance_id'] } }
      
      def self.find(*ids)
        response = Awsymandias::EC2.connection.describe_volumes :volume_ids => ids
        return [] if response['volumeSet'].nil?
        response['volumeSet']['item'].map do |volume_hash|
          self.build_from_service reformat_incoming_param_data(volume_hash)
        end
      end
   
    end
  end
end