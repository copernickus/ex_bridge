% Add mochiweb as dependency
Erlang.code.add_path $"deps/misultin/ebin"

% Load code inside lib
Code.unshift_path "lib"
Code.require "ex_bridge/misultin"

module Chat
  object Backend
    def constructor()
      { 'users: [] }
    end

    protected

    def init()
      { 'ok, self }
    end

    def handle_call(_request, _from)
      { 'reply, 'undef, self }
    end

    def handle_cast(_msg)
      { 'no_reply, self }
    end

    def handle_info(_msg)
      { 'no_reply, self }
    end

    def terminate(reason)
      'ok
    end

    def code_change(_old, _extra)
      { 'ok, self }
    end
  end

  module Server
    def start
      docroot = "examples/assets"

      options = {
        'port: 8080,
        'loop: -> (req) handle_http(ExBridge.request('misultin, req, 'docroot: docroot)),
        'ws_loop: -> (socket) handle_websocket(ExBridge.websocket('misultin, socket)),
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
        string = String.new(data)
        IO.puts "SOCKET BROWSER #{string}"

        case string.split(~r" \<\- ", 2)
        match ["msg", msg]
          % Do something
        match ["nick", nick]
          % Do something
        else
          socket.send "status <- received #{string}"
        end

        socket_loop(socket)
      match 'closed
        IO.puts "SOCKET CLOSED"
        self.exit(0)
      match { 'chat_server, { 'message, message } }
        string = String.new(message)
        IO.puts "SOCKET CHATSERVER #{string}"
        socket.send "output ! #{string}"
        socket_loop(socket)
      match other
        IO.puts "SOCKET UNKNOWN #{other}"
        socket_loop(socket)
      after 10000
        socket.send "tick"
        socket_loop(socket)
      end
    end

    def handle_http(request)
      status = case { request.request_method, request.path }
      match { 'GET, "/chat.html" }
        body = File.read File.join(request.docroot, "chat.html")
        request.respond 200, { "Content-Type": "text/html" }, body
      match { 'GET, path }
        request.serve_file path[1,-1]
      else
        request.respond 404, {}, "Not Found"
      end

      IO.puts "HTTP #{request.request_method} #{status} #{request.path}"
    end
  end
end

Chat::Server.start