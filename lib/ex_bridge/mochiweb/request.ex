% elixir: cache

object ExBridge::Mochiweb::Request
  proto ExBridge::Request

  def request_method
    Erlang.apply(@request, 'get, ['method])
  end

  def path
    raw_path = Erlang.apply(@request, 'get, ['raw_path])
    {path, _, _} = Erlang.mochiweb_util.urlsplit_path(raw_path)
    path.to_bin
  end

  def headers
    @headers || begin
      list = Erlang.mochiweb_headers.to_list(Erlang.apply(@request, 'get, ['headers]))
      list = list.map -> ({x,y}) { upcase_headers(x.to_char_list), y.to_bin }
      OrderedDict.from_list list
    end
  end

  def cookies
    @cookies || begin
      list = Erlang.apply(@request, 'parse_cookie, [])
      OrderedDict.from_list list.map(-> ({x,y}) { String.new(x), String.new(y) })
    end
  end

  def build_response
    ExBridge::Mochiweb::Response.new(@request, @options)
  end
end