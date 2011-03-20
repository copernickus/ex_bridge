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
    self.start -> (r) respond_server(r)
    response = HTTPClient.request('get, "http://127.0.0.1:3001/")
    { 200, headers, "Hello world\n" } = response
    "text/plain" = headers["Content-Type"]
  end

  private

  def respond_server(request)
    request.respond 200, { "Content-Type": "text/plain" }, "Hello world\n"
  end
end