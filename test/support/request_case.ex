% Handles all tests for the request bridge. The server_options returns a
% function that dispatches an internal loop method based on the request path.
module RequestCase
  def server_options(server_name, port)
    docroot = File.expand_path("../../..", __FILE__)

    {
      'port: port,
      'loop: -> (req)
        request = ExBridge.request(server_name, req, 'docroot: docroot)
        try
          method = request.path[1, -1] + "_loop"
          self.__send__ method.to_atom, [request]
        catch error: kind
          request.respond 500, {}, { error, kind, self.__stacktrace__ }.inspect
        end
      end
    }
  end

  % Tests

  def respond_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/respond")
    { 200, headers, "Hello world\n" } = response
    "text/plain" = headers["Content-Type"]
  end

  def serve_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_file")
    { 200, _headers, body } = response
    self.assert_include "% ASSERTION FLAG", body
  end

  def serve_file_with_headers_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_file_with_headers")
    { 200, headers, _body } = response
    "attachment; filename=\"cool.ex\"" = headers["Content-Disposition"]
  end

  def serve_forbidden_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_forbidden_file")
    { 403, _headers, _body } = response
  end

  def serve_unavailable_file_test
    response = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/serve_unavailable_file")
    { 404, _headers, _body } = response
  end

  def accessors_test
    { 200, _headers, _body } = HTTPClient.request('get, "http://127.0.0.1:#{self.port}/accessors")
  end

  protected

  def respond_loop(request)
    request.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end

  def serve_file_loop(request)
    request.serve_file "test/test_helper.ex"
  end

  def serve_file_with_headers_loop(request)
    request.serve_file "test/test_helper.ex", "Content-Disposition": "attachment; filename=\"cool.ex\""
  end

  def serve_unavailable_file_loop(request)
    request.serve_file "test/test_helper.ex.unknown"
  end

  def serve_forbidden_file_loop(request)
    request.serve_file "test/../test/test_helper.ex"
  end

  def accessors_loop(request)
    'GET         = request.request_method
    "/accessors" = request.path
    request.respond 200, {}, "Ok"
  end
end