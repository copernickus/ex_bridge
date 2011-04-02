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

  def build_response
    ExBridge::Mochiweb::Response.new(@request, @docroot)
  end
end