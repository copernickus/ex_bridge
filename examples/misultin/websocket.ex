% Add mochiweb as dependency
Erlang.code.add_path $"deps/misultin/ebin"

% Load code inside lib
Code.unshift_path "lib"
Code.require "ex_bridge/misultin"

module Chat
  module Server
    def start
      docroot = "examples/assets"

      options = {
        'port: 8080,
        'loop: -> (req) handle_http(ExBridge.request('misultin, req, 'docroot: docroot)),
        'ws_loop: -> (socket) handle_websocket(socket),
        'ws_autoexit: false
      }

      { 'ok, _ } = Erlang.misultin.start_link options.to_list
    end

    def stop
      Erlang.misultin.stop
    end

    def handle_websocket(socket)
      socket_loop(socket)
    end

    def socket_loop(socket)
      receive
      match {'browser, data}
        Erlang.apply(socket, 'send, [$"output ! OMG"])
        socket_loop(socket)
      match 'closed
        'closed
      match { 'chat_server, { 'message, message } }
        Erlang.apply(socket, 'send, [[$"output ! ", message]])
        socket_loop(socket)
      match _
        socket_loop(socket)
      after 10000
        Erlang.apply(socket, 'send, [$"clock ! tick" + Erlang.io_lib.fwrite($"~p", [Erlang.time])])
        socket_loop(socket)
      end
    end

    def handle_http(request)
      IO.puts "HTTP #{request.request_method} #{request.path}"
      case { request.request_method, request.path }
      match { 'GET, "/chat.html" }
        body = File.read File.join(request.docroot, "chat.html")
        request.respond 200, { "Content-Type": "text/html" }, body
      match { 'GET, path }
        request.serve_file path[1,-1]
      else
        request.respond 404, {}, "Not Found"
      end
    end
  end
end

Chat::Server.start