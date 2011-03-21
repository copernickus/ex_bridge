% Add mochiweb as dependency
Erlang.code.add_path $"deps/misultin/ebin"

% Load code inside lib
Code.unshift_path "lib"
Code.require "ex_bridge/misultin"

module Chat
  object Backend
    module Mixin
      def start
        { 'ok, _ } = GenServer.start_link({'local, 'chat_backend}, self.new, [])
      end

      def new_user
        GenServer.call('chat_backend, 'new_user)
      end

      def set_nick(nick)
        GenServer.cast('chat_backend, { 'set_nick, Process.self, nick })
      end

      def send_message(message)
        GenServer.cast('chat_backend, { 'message, Process.self, message })
      end
    end

    def constructor()
      { 'users: {:} }
    end

    def broadcast(message)
      @users.each do (pid, _)
        pid <- { 'chat_server, { 'message, message } }
      end
    end

    protected

    def init()
      Process.flag('trap_exit, true)
      { 'ok, self }
    end

    def handle_call('new_user, { pid, _ref })
      Process.link(pid) % Link to the given socket process
      updated = self.update_ivar('users, _.set(pid, "Unknown"))
      { 'reply, 'ok, updated }
    end

    def handle_call(_request, _from)
      { 'reply, 'undef, self }
    end

    def handle_cast({ 'set_nick, from, nick })
      updated = self.update_ivar('users, _.set(from, nick))
      { 'noreply, updated }
    end

    def handle_cast({ 'message, from, text })
      broadcast "#{@users[from]}: #{text}"
      { 'noreply, self }
    end

    def handle_cast(_request)
      { 'noreply, self }
    end

    def handle_info({ 'EXIT, from, _ })
      updated = self.update_ivar('users, _.delete(from))
      updated.broadcast "#{@users[from]} left the room."
      { 'noreply, updated }
    end

    def handle_info(_request)
      { 'noreply, self }
    end

    def terminate(_reason)
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
        'ws_loop: -> (socket) handle_websocket(ExBridge.websocket('misultin, socket))
      }

      { 'ok, _ } = Erlang.misultin.start_link options.to_list
    end

    def stop
      Erlang.misultin.stop
    end

    def handle_websocket(socket)
      Chat::Backend.new_user
      socket_loop(socket)
    end

    def socket_loop(socket)
      receive
      match {'browser, data}
        string = String.new(data)
        IO.puts "SOCKET BROWSER #{string}"

        case string.split(~r" \<\- ", 2)
        match ["msg", msg]
          Chat::Backend.send_message(msg)
        match ["nick", nick]
          Chat::Backend.set_nick(nick)
        else
          socket.send "status <- received #{string}"
        end

        socket_loop(socket)
      match { 'chat_server, { 'message, message } }
        string = String.new(message)
        socket.send "output <- #{string}"
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

Chat::Backend.start
Chat::Server.start

IO.puts "Starting on http://127.0.0.1:8080/"