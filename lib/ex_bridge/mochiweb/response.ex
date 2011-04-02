% elixir: cache

object ExBridge::Mochiweb::Response
  proto ExBridge::Response

  def respond(status, headers, body)
    response = { status, convert_headers(headers), body.to_bin }
    Erlang.apply(@request, 'respond, [response])
    status
  end

  def serve_file(path, headers := [])
    serve_file_conditionally path, do
      Erlang.apply(@request, 'serve_file, [path.to_char_list, @docroot, convert_headers(headers)])
    end
  end

  private

  def convert_headers(headers)
    headers.to_list.map -> ({key, value}) {key.to_bin, value.to_bin}
  end
end