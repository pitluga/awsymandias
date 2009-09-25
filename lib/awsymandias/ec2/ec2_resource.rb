class EC2Resource
  include Awsymandias::Support::Hash
  extend  Awsymandias::Support::Hash # reformat_incoming_param_data
  
  class << self
    def metadata
      @@metadata ||= {}
    end
    
    def attributes(*names)
      names.each do |name|
        complex_attribute name, lambda { |hash| hash[name] || hash[name.to_s] }
      end
    end
    
    def complex_attribute(name, mapper)
      self.send(:define_method, name) { instance_variable_get :"@#{name}" }
      metadata[name] = mapper
    end
    
    def build_from_service(aws_hash)
      attrs = {}
      metadata.each_pair do |name, mapper|
        attrs[name] = mapper.call(aws_hash)
        attrs
      end
      self.new(attrs)
    end
    
    def nilsafe(&block)
      yield
    rescue
      nil
    end
  end
  
  def initialize(attrs = {})
    self.class.metadata.keys.each do |attribute|
      instance_variable_set :"@#{attribute}", attrs[attribute]
    end
  end
  
end