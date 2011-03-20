% elixir: cache

object ExBridge::Mochiweb::Request
  proto ExBridge::Request

  def respond(status, headers, body)
    response = { status, convert_headers(headers), body.to_bin }
    Erlang.apply(@request, 'respond, [response])
  end

  def serve_file(path, headers := [])
    if @docroot
      if ~r"\.\.".match?(path)
        respond(403, {}, "Forbidden")
      else
        Erlang.apply(@request, 'serve_file, [path.to_char_list, @docroot, convert_headers(headers)] )
      end
    else
      self.error { 'nodocroot, "Cannot send file without docroot" }
    end
  end

  private

  def convert_headers(headers)
    headers.to_list.map -> ({key, value}) {key.to_bin, value.to_bin}
  end
end