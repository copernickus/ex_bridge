% elixir: cache

module ExBridge::Request
  attr_reader ['docroot]

  def initialize(request, options)
    docroot = options['docroot]
    @('request: request, 'docroot: docroot && docroot.to_bin)
  end
end