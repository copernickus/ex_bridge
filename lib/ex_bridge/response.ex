% elixir: cache [date_time]

module ExBridge::Response
  % TODO: Maybe an ordered dict is not the best/fastest way to represent the headers
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

  % TODO: Maybe an ordered dict is not the best/fastest way to represent cookies
  object Cookies
    def initialize(response, cookies)
      @('response: response, 'cookies: cookies)
    end

    def [](key)
      @cookies[key]
    end

    def set(key, value, options := {:})
      @response.cookies @cookies.set(key, options.set('value, value))
    end

    def delete(key, options := {:})
      set(key, "deleted", options.merge('expires: unix_1970))
    end

    def to_dict
      @cookies
    end

    private

    def unix_1970
      DateTime.new({{1970,1,1},{0,0,1}})
    end
  end

  attr_reader   ['docroot]
  attr_writer   ['headers, 'cookies]
  attr_accessor ['status, 'body, 'file]

  def initialize(request, options)
    docroot = options['docroot]
    @('request: request, 'docroot: docroot, 'headers: {:}, 'cookies: {:})
  end

  def headers
    ExBridge::Response::Headers.new(self, @headers)
  end

  def cookies
    ExBridge::Response::Cookies.new(self, @cookies)
  end

  def respond
    if @file
      self.serve_file(@file, @headers)
    else
      headers = serialize_cookies(@headers, @cookies)
      self.respond(@status || 200, headers, @body || "")
    end
  end

  def respond(given)
    body(given).respond
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

  private

  def serialize_cookies(headers, {:})
    headers
  end

  def serialize_cookies(headers, cookies)
    headers.to_list + cookies.to_list.map -> (c) { "Set-Cookie", serialize_cookie(c) }
  end

  def serialize_cookie({key, options})
    string = "#{key}=#{options['value]}"

    if expires = options['expires]
      string = string + "; expires=#{serialize_expires(expires)}"
    end

    if path = options['path]
      string = string + "; path=#{path}"
    end

    if domain = options['domain]
      string = string + "; domain=#{domain}"
    end

    if options['secure]
      string = string + "; secure"
    end

    unless options['httponly] == false
      string = string + "; httponly"
    end

    string
  end

  def serialize_expires(expires)
    % TODO Duck type when we have respond_to?
    if expires.__parent_name__ == 'Time
      expires.rfc1123
    else
      expires
    end
  end
end