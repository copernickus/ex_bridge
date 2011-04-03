Erlang.code.add_path $"deps/ibrowse/ebin"
{ 'ok, _ } = Erlang.ibrowse.start()

module HTTPClient
  def request(verb, path, headers := {:})
    {'ok, status, headers, body} = Erlang.ibrowse.send_req(path.to_char_list, decode_headers(headers), verb)
    { Erlang.list_to_integer(status), encode_headers(headers), body.to_bin }
  end

  private

  def decode_headers(headers)
    headers.to_list.map -> ({k,v}) { k.to_char_list, v.to_char_list }
  end

  def encode_headers(headers)
    HTTPClient::PropList.new headers.map -> ({k,v}) { k.to_bin, v.to_bin }
  end

  object PropList
    def initialize(list)
      @('list: Erlang.lists.sort(list))
    end

    def [](key)
      Erlang.proplists.get_all_values(key, @list)
    end
  end
end