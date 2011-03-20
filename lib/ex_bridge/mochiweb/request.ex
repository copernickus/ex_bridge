% elixir: cache

object ExBridge::Mochiweb::Request
  def constructor(request)
    { 'request: request }
  end

  def respond(status, headers, body)
    response = { status, convert_headers(headers), body.to_bin }
    Erlang.apply(@request, 'respond, [response])
  end

  private

  def convert_headers(headers)
    headers.to_list.map -> ({key, value}) {key.to_bin, value.to_bin}
  end
end