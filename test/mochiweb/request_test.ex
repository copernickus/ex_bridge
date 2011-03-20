Code.require File.expand_path("../test_helper", __FILE__)

object Mochiweb::RequestTest
  proto ExUnit::Case
  proto RequestCase

  % Tests that are not supported

  % Hooks

  def server_name
    'mochiweb
  end

  % Hook to start each server.
  def start(function)
    options = self.server_options(function).merge 'name: 'mochiweb_test
    { 'ok, _ } = Erlang.mochiweb_http.start options.to_list
  end

  def teardown(_)
    'ok = Erlang.mochiweb_http.stop 'mochiweb_test
  end
end