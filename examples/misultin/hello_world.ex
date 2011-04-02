% This is a simple example of running Misultin with ExBridge.
% Notice that the code to start a given webserver is not
% agnostic, but the request interaction is.
%
% You can run this example from the repo root directoy:
%
%     elixir --no-halt examples/misultin/hello_world.ex
%
% And then access localhost:3000 in your browser.

% Add mochiweb as dependency
Erlang.code.add_path $"deps/misultin/ebin"

% Load code inside lib
Code.unshift_path "lib"
Code.require "ex_bridge/misultin"

module MisultinSample
  def start
    options = {
      'port: 3000,
      'loop: -> (req) loop(ExBridge.request('misultin, req))
    }

    Erlang.misultin.start_link options.to_list
  end

  private

  def loop(request)
    response = request.build_response
    response.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end
end

{ 'ok, pid } = MisultinSample.start