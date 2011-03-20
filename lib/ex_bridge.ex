% elixir: cache

module ExBridge
  def request('mochiweb, request)
    ExBridge::Mochiweb::Request.new(request)
  end

  def request('misultin, request)
    ExBridge::Misultin::Request.new(request)
  end

  def request(other, _)
    self.error { 'nobridge, "No bridge for #{other.inspect}" }
  end
end