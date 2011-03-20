% elixir: cache

object ExBridge::Misultin::Websocket
  proto ExBridge::Websocket

  def send(message)
    Erlang.apply(@socket, 'send, [message.to_bin])
  end
end