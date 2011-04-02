% elixir: cache

object ExBridge::Misultin::Request
  proto ExBridge::Request

  def request_method
    Erlang.apply(@request, 'get, ['method])
  end

  def path
    { 'abs_path, path } = Erlang.apply(@request, 'get, ['uri])
    String.new path
  end

  def build_response
    ExBridge::Misultin::Response.new(@request, @docroot)
  end
end