% elixir: cache

module ExBridge
  def request('mochiweb, request, options := {:})
    ExBridge::Mochiweb::Request.new(request, options)
  end

  def request('misultin, request, options := {:})
    ExBridge::Misultin::Request.new(request, options)
  end

  def request(other, _, _ := nil)
    self.error { 'nobridge, "No bridge for #{other.inspect}" }
  end

  module Request
    def constructor(request, options)
      docroot = options['docroot]
      { 'request: request, 'docroot: docroot && docroot.to_bin }
    end
  end
end