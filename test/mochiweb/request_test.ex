Code.require File.expand_path("../test_helper", __FILE__)

object Mochiweb::RequestTest
  proto ExUnit::Case

  def respond_test
    start -> (r) basic_respond(r)
    response = HTTPClient.request('get, "http://127.0.0.1:3001/")
    { 200, headers, "Hello world\n" } = response
    "text/plain" = headers["Content-Type"]
  end

  def teardown(_)
    Erlang.mochiweb_http.stop 'mochiweb_test
  end

  private

  def start(function)
    options = {
      'name: 'mochiweb_test,
      'port: 3001,
      'loop: -> (req)
        try
          function(ExBridge.request('mochiweb, req))
        catch error: kind
          IO.puts { error, kind }
        end
      end
    }

    { 'ok, _ } = Erlang.mochiweb_http.start options.to_list
  end

  def basic_respond(request)
    request.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end
end