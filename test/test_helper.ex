Code.unshift_path File.expand_path("..", __FILE__)
Code.unshift_path File.expand_path("../../lib", __FILE__)

Code.require "ex_bridge"

% Configure ExUnit, no options supported yet.
ExUnit.configure {:}

% Start ibrowse client for testing
Erlang.code.add_path $"deps/ibrowse/ebin"
{ 'ok, _ } = Erlang.ibrowse.start()

module HTTPClient
  def request(verb, path)
    {'ok, status, headers, body} = Erlang.ibrowse.send_req(path.to_char_list, [], verb)
    { Erlang.list_to_integer(status), convert_headers(headers), String.new(body) }
  end

  private

  def convert_headers(headers)
    OrderedDict.from_list(headers.map -> ({k,v}) { String.new(k), String.new(v) })
  end
end

module RequestCase
  def respond_test
    self.start -> (r) respond_loop(r)
    response = HTTPClient.request('get, "http://127.0.0.1:#{port}/")
    { 200, headers, "Hello world\n" } = response
    "text/plain" = headers["Content-Type"]
  end

  def serve_file_test
    self.start -> (r) serve_file_loop(r)
    response = HTTPClient.request('get, "http://127.0.0.1:#{port}/")
    { 200, _headers, body } = response
    self.assert_include "module RequestCase", body
  end

  def serve_file_with_headers_test
    self.start -> (r) serve_file_with_headers_loop(r)
    response = HTTPClient.request('get, "http://127.0.0.1:#{port}/")
    { 200, headers, _body } = response
    "attachment; filename=\"cool.ex\"" = headers["Content-Disposition"]
  end

  protected

  def port
    3001
  end

  def server_options(function)
    docroot = File.expand_path("../..", __FILE__)

    {
      'port: port,
      'loop: -> (req)
        request = ExBridge.request(self.server_name, req, 'docroot: docroot)
        try
          function(request)
        catch error: kind
          request.respond 500, {}, { error, kind }.inspect
        end
      end
    }
  end

  private

  def respond_loop(request)
    request.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end

  def serve_file_loop(request)
    request.serve_file "test/test_helper.ex"
  end

  def serve_file_with_headers_loop(request)
    request.serve_file "test/test_helper.ex", "Content-Disposition": "attachment; filename=\"cool.ex\""
  end
end