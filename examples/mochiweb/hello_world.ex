% This is a simple example of running Mochiweb with ExBridge.
% Notice that the code to start a given webserver is not
% agnostic, but the request interaction is.
%
% You can run this example from the repo root directoy:
%
%     elixir --no-halt examples/mochiweb/hello_world.ex
%
% And then access localhost:3000 in your browser.

% Add mochiweb as dependency
Erlang.code.add_path $"deps/mochiweb/ebin"

% Load code inside lib
Code.unshift_path "lib"
Code.require "ex_bridge/mochiweb"

module MochiwebSample
  def start
    options = {
      'name: 'mochiweb_sample,
      'port: 3000,
      'loop: -> (req) loop(ExBridge.request('mochiweb, req))
    }

    Erlang.mochiweb_http.start options.to_list
  end

  private

  def loop(request)
    request.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end
end

{ 'ok, pid } = MochiwebSample.start