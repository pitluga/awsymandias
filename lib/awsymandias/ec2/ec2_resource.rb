class EC2Resource
  include Awsymandias::Support::Hash
  extend  Awsymandias::Support::Hash # reformat_incoming_param_data
  
  class << self
    def metadata
      @metadata ||= {}
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
      self.new.load(aws_hash)
    end
    
    def nilsafe(&block)
      yield
    rescue
      nil
    end
  end

  def load(aws_hash)
    self.class.metadata.each_pair do |name, mapper|
      instance_variable_set :"@#{name}", mapper.call(aws_hash)
    end
    self
  end
  
  def initialize(attrs = {})
    self.class.metadata.keys.each do |attribute|
      instance_variable_set :"@#{attribute}", attrs[attribute]
    end
  end
  
end