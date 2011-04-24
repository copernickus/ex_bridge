module ExBridge
  def request('mochiweb, request, options := {:})
    ExBridge::Mochiweb::Request.new(request, options)
  end

  def request('misultin, request, options := {:})
    ExBridge::Misultin::Request.new(request, options)
  end

  def request(other, _, _ := nil)
    self.error { 'nobridge, "No request bridge for #{other.inspect}" }
  end

  def websocket('misultin, socket)
    ExBridge::Misultin::Websocket.new(socket)
  end

  def websocket(other, _)
    self.error { 'nobridge, "No websocket bridge for #{other.inspect}" }
  end
end