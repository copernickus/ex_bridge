Code.unshift_path File.expand_path("..", __FILE__)
Code.unshift_path File.expand_path("../../lib", __FILE__)

Code.require "ex_bridge"

% Configure ExUnit, no options supported yet.
ExUnit.configure {:}

% Start ibrowse client for testing
Erlang.code.add_path $"deps/ibrowse/ebin"
'ok = Erlang.ibrowse.start()

module HTTPClient
  def request(verb, path)
    {'ok, status, headers, body} = Erlang.ibrowse.send_req(path.to_char_list, [], verb)
    { status, convert_headers(headers), String.new(body) }
  end

  private

  def convert_headers(headers)
    OrderedDict.new(headers.map -> ({k,v}) { String.new(k), String.new(v) })
  end
end