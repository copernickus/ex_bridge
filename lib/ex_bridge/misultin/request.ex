% elixir: cache

object ExBridge::Misultin::Request
  proto ExBridge::Request

  def respond(status, headers, body)
    response = [ status, convert_headers(headers), body.to_bin ]
    Erlang.apply(@request, 'respond, response)
    status
  end

  def request_method
    Erlang.apply(@request, 'get, ['method])
  end

  def path
    { 'abs_path, path } = Erlang.apply(@request, 'get, ['uri])
    String.new path
  end

  def serve_file(path, [] := [])
    self.serve_file_conditionally path, -> Erlang.apply(@request, 'file, [File.join(@docroot, path).to_bin])
  end

  def serve_file(_path, _headers)
    self.error { 'notsupported, "Sending headers while serving file not supported by misultin" }
  end

  private

  def convert_headers(headers)
    headers.to_list.map -> ({key, value}) {key.to_char_list, value.to_char_list}
  end
end