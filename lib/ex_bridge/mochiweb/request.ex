% elixir: cache

object ExBridge::Mochiweb::Request
  proto ExBridge::Request

  def respond(status, headers, body)
    response = { status, convert_headers(headers), body.to_bin }
    Erlang.apply(@request, 'respond, [response])
  end

  def request_method
    Erlang.apply(@request, 'get, ['method])
  end

  def path
    raw_path = Erlang.apply(@request, 'get, ['raw_path])
    {path, _, _} = Erlang.mochiweb_util.urlsplit_path(raw_path)
    String.new path
  end

  def serve_file(path, headers := [])
    self.serve_file_conditionally path, do
      Erlang.apply(@request, 'serve_file, [path.to_char_list, @docroot, convert_headers(headers)])
    end
  end

  private

  def convert_headers(headers)
    headers.to_list.map -> ({key, value}) {key.to_bin, value.to_bin}
  end
end