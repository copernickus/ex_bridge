% elixir: cache

module ExBridge::Response
  attr_reader ['docroot, 'headers]
  attr_accessor ['body, 'file, 'status]

  def initialize(request, docroot)
    @('request: request, 'docroot: docroot && docroot.to_bin, 'headers: {:})
  end

  def merge_headers(headers)
    @('headers, @headers.merge(headers))
  end

  def clear_headers
    @('headers, {:})
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