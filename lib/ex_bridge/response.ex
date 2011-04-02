% elixir: cache

module ExBridge::Response
  object Headers
    def initialize(response, headers)
      @('response: response, 'headers: headers)
    end

    def [](key)
      @headers[key]
    end

    def merge(headers)
      @response.headers(@headers.merge(headers))
    end

    def clear
      @response.headers({:})
    end

    def delete(key)
      @response.headers(@headers.delete(key))
    end

    def to_dict
      @headers
    end
  end

  attr_reader   ['docroot]
  attr_writer   ['headers]
  attr_accessor ['status, 'body, 'file]

  def initialize(request, docroot)
    @('request: request, 'docroot: docroot && docroot.to_bin, 'headers: {:})
  end

  def headers
    ExBridge::Response::Headers.new(self, @headers)
  end

  def respond
    if @file
      self.serve_file(@file, @headers)
    else
      self.respond(@status, @headers, @body)
    end
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
      error { 'nodocroot, "Cannot send file without docroot" }
    end
  end
end