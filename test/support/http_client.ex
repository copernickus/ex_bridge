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