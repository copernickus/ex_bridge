Code.require File.expand_path("../test_helper", __FILE__)

object Mochiweb::RequestTest
  proto ExUnit::Case
  proto RequestCase

  % Hook to start each server.
  def start(function)
    options = {
      'port: 3001,
      'loop: -> (req) function(ExBridge.request('misultin, req))
    }

    { 'ok, _ } = Erlang.misultin.start_link options.to_list
  end

  def teardown(_)
    Erlang.misultin.stop
  end
end