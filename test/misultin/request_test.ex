Code.require File.expand_path("../test_helper", __FILE__)

object Misultin::RequestTest
  proto ExUnit::Case
  proto RequestCase

  % Tests that are not supported

  def serve_file_with_headers_test
  end

  % Hooks

  def server_name
    'misultin
  end

  % Hook to start each server.
  def start(function)
    options = self.server_options(function)
    { 'ok, _ } = Erlang.misultin.start_link options.to_list
  end

  def teardown(_)
    Erlang.misultin.stop
  end
end