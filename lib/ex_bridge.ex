% elixir: cache

module ExBridge
  def request('mochiweb, request, options := {:})
    ExBridge::Mochiweb::Request.new(request, options)
  end

  def request('misultin, request, options := {:})
    ExBridge::Misultin::Request.new(request, options)
  end

  def request(other, _, _ := nil)
    self.error { 'nobridge, "No request bridge for #{other.inspect}" }
  end

  def websocket('misultin, socket)
    ExBridge::Misultin::Websocket.new(socket)
  end

  def websocket(other, _)
    self.error { 'nobridge, "No websocket bridge for #{other.inspect}" }
  end

  module Websocket
    def constructor(socket)
      { 'socket: socket }
    end
  end

  module Request
    attr_reader ['docroot]

    def constructor(request, options)
      docroot = options['docroot]
      { 'request: request, 'docroot: docroot && docroot.to_bin }
    end

    def serve_file_conditionally(path, function)
      if @docroot
        if ~r"\.\.".match?(path)
          self.respond(403, {:}, "Forbidden")
        else
          joined = File.join(@docroot, path)
          if File.regular?(joined)
            function()
            200
          else
            self.respond(404, {:}, "Not Found")
          end
        end
      else
        self.error { 'nodocroot, "Cannot send file without docroot" }
      end
    end
  end
end