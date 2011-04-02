% elixir: cache

module ExBridge::Response
  attr_reader ['docroot]

  def initialize(request, docroot)
    @('request: request, 'docroot: docroot && docroot.to_bin)
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