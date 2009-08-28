module Awsymandias
  module EC2
    class ApplicationStack
      attr_reader :name, :instances, :sdb_domain

      DEFAULT_SDB_DOMAIN = "application-stack"

      class << self
        def find(name)
          returning(new(name)) do |stack|
            return nil unless stack.launched?
          end
        end

        def launch(name, opts={})
          returning(new(name, opts)) do |stack|
            stack.launch
          end
        end
      end

      def initialize(name, opts={})
        opts.assert_valid_keys! :instances

        @name       = name
        @instances  = opts[:instances] || {}
        @sdb_domain = opts[:sdb_domain] || DEFAULT_SDB_DOMAIN
        @running_instances  = {}
        yield self if block_given?
      end

      def instance(*names)
        opts = names.extract_options!
        names.each do |name|
          @instances[name] = opts
          self.metaclass.send(:define_method, name) { @running_instances[name] }
        end
      end

      def launch
        @instances.each do |name, params| # TODO Optimize this for a single remote call.
          @running_instances[name] = Awsymandias::EC2::Instance.launch(params)
        end
        store_role_to_instance_id_mapping!
        self
      end

      def reload
        raise "Can't reload unless launched" unless launched?
        @running_instances.values.each(&:reload) # TODO Optimize this for a single remote call.
        self
      end

      def terminate!
        @running_instances.values.each(&:terminate!) # TODO Optimize this for a single remote call.
        remove_role_to_instance_id_mapping!
        self
      end

      def launched?
        @running_instances.any? || ( @running_instances = retrieve_role_to_instance_id_mapping ).any?
      end

      def running?
        launched? && @running_instances.values.all?(&:running?)
      end

      def port_open?(port)
        @running_instances.values.all? { |instance| instance.port_open?(port) }
      end

      def running_cost
        return Money.new(0) unless launched?
        @running_instances.values.sum { |instance| instance.running_cost }
      end

      def inspect
        ( [ "Environment #{@name}, running? #{running?}" ] + roles.map do |role_name, opts|
          "** #{role_name}: #{opts.inspect}"
        end ).join("\n")
      end

      private

      def store_role_to_instance_id_mapping!
        Awsymandias::SimpleDB.put @sdb_domain, @name, ( returning({}) do |h|
          @running_instances.each {|role_name, instance| h[role_name] = instance.instance_id}
        end )
      end

      def remove_role_to_instance_id_mapping!
        Awsymandias::SimpleDB.delete @sdb_domain, @name
      end

      def retrieve_role_to_instance_id_mapping
        returning(Awsymandias::SimpleDB.get(@sdb_domain, @name)) do |mapping|
          unless mapping.empty?
            live_instances = Awsymandias::EC2::Instance.find(:all, :instance_ids => mapping.values.flatten).index_by(&:instance_id)
            mapping.each do |role_name, instance_id|
              mapping[role_name] = live_instances[instance_id.first]
            end
          end
        end
      end

    end

  end
end
