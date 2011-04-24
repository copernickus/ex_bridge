% Handles all tests for the request/response bridge. The server_options returns a
% function that dispatches an internal loop method based on the request path.
module ServerCase
  def server_options(server_name, port)
    docroot = File.expand_path("../../..", __FILE__)

    {
      'port: port,
      'loop: -> (req)
        request  = ExBridge.request(server_name, req, 'docroot: docroot)
        response = request.build_response
        try
          method = request.path[1, -1] + "_loop"
          self.__send__ method.to_atom, [request, response]
        catch error: kind
          response.respond 500, {}, { error, kind, self.__stacktrace__ }.inspect
        end
      end
    }
  end

  % Tests

  def respond_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/respond")
    { 200, headers, "Hello world\n" } = response
    ["text/plain"] = headers["Content-Type"]
  end

  def respond_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/respond_file")
    { 200, _headers, body } = response
    self.assert_include "% ASSERTION FLAG", body
  end

  def respond_args_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/respond_args")
    { 200, headers, "Hello world\n" } = response
    ["text/plain"] = headers["Content-Type"]
  end

  def serve_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_file")
    { 200, _headers, body } = response
    self.assert_include "% ASSERTION FLAG", body
  end

  def serve_file_with_headers_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_file_with_headers")
    { 200, headers, _body } = response
    ["attachment; filename=\"cool.ex\""] = headers["Content-Disposition"]
  end

  def serve_forbidden_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_forbidden_file")
    { 403, _headers, _body } = response
  end

  def serve_unavailable_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_unavailable_file")
    { 404, _headers, _body } = response
  end

  def response_cookies_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/response_cookies")
    { 200, headers, "" } = response
    cookies = headers["Set-Cookie"]
    3 = cookies.size
    "key1=value1; httponly" = cookies[0]
    "key2=value2; path=/blog; domain=plataformatec.com.br; secure" = cookies[1]
    "key3=deleted; expires=1970-01-01 00:00:01; path=/blog; httponly" = cookies[2]
  end

  def request_accessors_test
    { 200, _headers, _body } = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/request_accessors")
  end

  def request_headers_test
    { 200, _headers, _body } = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/request_headers", "unknown-header": "set")
  end

  def request_cookies_test
    { 200, _headers, _body } = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/request_cookies", "Cookie": "key1=value1; key2=value2")
  end

  % Server loops

  def respond_loop(_request, response)
    response = response.status(200)
    200 = response.status

    response = response.headers.merge "Content-Type": "text/plain"
    { "Content-Type": "text/plain" } = response.headers.to_dict
    "text/plain" = response.headers["Content-Type"]
    another_response = response.headers.clear
    {:} = another_response.headers.to_dict

    response = response.body("Hello world\n")
    "Hello world\n" = response.body

    response.respond
  end

  def respond_file_loop(_request, response)
    response = response.file "test/test_helper.ex"
    "test/test_helper.ex" = response.file
    response.respond
  end

  def respond_args_loop(_request, response)
    response.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end

  def serve_file_loop(_request, response)
    response.serve_file "test/test_helper.ex"
  end

  def serve_file_with_headers_loop(_request, response)
    response.serve_file "test/test_helper.ex", "Content-Disposition": "attachment; filename=\"cool.ex\""
  end

  def serve_unavailable_file_loop(_request, response)
    response.serve_file "test/test_helper.ex.unknown"
  end

  def serve_forbidden_file_loop(_request, response)
    response.serve_file "test/../test/test_helper.ex"
  end

  def response_cookies_loop(_request, response)
    response = response.cookies.set 'key1, "value1"
    response = response.cookies.set 'key2, "value2", 'domain: "plataformatec.com.br", 'path: "/blog", 'secure: true, 'httponly: false
    response = response.cookies.delete 'key3, 'path: "/blog"
    response.respond
  end

  def request_accessors_loop request, response
    'GET = request.request_method
    "/request_accessors" = request.path
    response.respond 200, {}, "Ok"
  end

  def request_headers_loop request, response
    ["127.0.0.1", _] = request.headers["Host"].split(~r(:))
    request = request.memoize!('headers)
    "0" = request.headers["Content-Length"]
    "set" = request.headers["Unknown-Header"]
    response.respond 200, {}, "Ok"
  end

  def request_cookies_loop request, response
    ["127.0.0.1"] = request.cookies
    response.respond 200, {}, "Ok"
  end
end