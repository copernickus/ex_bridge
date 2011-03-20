% elixir: cache

module ExBridge
  def request('mochiweb, request)
    ExBridge::Mochiweb::Request.new(request)
  end
end