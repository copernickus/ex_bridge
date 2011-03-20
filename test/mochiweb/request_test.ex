Code.require File.expand_path("../test_helper", __FILE__)

object Mochiweb::RequestTest
  proto ExUnit::Case
  proto RequestCase

  % Hook to start each server.
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

  def teardown(_)
    Erlang.mochiweb_http.stop 'mochiweb_test
  end
end