class SimpleDBStub
  def initialize
    @store = {}
  end

  def list_domains
    [ @store.keys ]
  end

  def put_attributes(domain, name, attributes)
    @store[domain][name] = attributes
  end

  def get_attributes(domain, name)
    @store[domain][name]
  end

  def delete_attributes(domain, name)
    @store[domain][name] = nil
  end

  def create_domain(domain)
    @store[domain] = {}
  end
end