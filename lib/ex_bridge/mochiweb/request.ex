% elixir: cache

object ExBridge::Mochiweb::Request
  proto ExBridge::Request

  def request_method
    Erlang.apply(@request, 'get, ['method])
  end

  def path
    raw_path = Erlang.apply(@request, 'get, ['raw_path])
    {path, _, _} = Erlang.mochiweb_util.urlsplit_path(raw_path)
    String.new path
  end

  def headers
    @headers || begin
      list = Erlang.mochiweb_headers.to_list(Erlang.apply(@request, 'get, ['headers]))
      list = list.map -> ({x,y}) { upcase_headers(x.to_char_list), String.new(y) }
      OrderedDict.from_list list
    end
  end

  def build_response
    ExBridge::Mochiweb::Response.new(@request, @options)
  end
end