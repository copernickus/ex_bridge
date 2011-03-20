Code.require File.expand_path("../test_helper", __FILE__)

object Mochiweb::RequestTest
  proto ExUnit::Case

  def respond_test
    start -> (r) basic_respond(r)
    response = HTTPClient.request('get, "http://localhost:3000/")
    { 200, { "Content-Type": "text/plain" }, "Hello World\n" } = response
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
    Erlang.timer.sleep(5000)
  end

  def basic_respond(request)
    request.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end
end