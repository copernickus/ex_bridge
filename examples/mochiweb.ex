% Add mochiweb as dependency
Erlang.code.add_path $"deps/mochiweb-1.5.2/ebin"

module MochiwebSample
  def start
    options = {
      'name: 'http_8443,
      'port: 8443,
      'loop: -> (req) loop(req)
    }

    Erlang.mochiweb_http.start options.to_list
  end

  private

  def loop(req)
    Erlang.apply(req, 'respond, [{200, [{$"Content-Type", $"text/html"}], $"Hello world"}])
  end
end

MochiwebSample.start