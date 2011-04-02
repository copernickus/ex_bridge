Code.require File.expand_path("../../test_helper", __FILE__)
Code.require "ex_bridge/mochiweb"

Erlang.code.add_path $"deps/mochiweb/ebin"

options = ServerCase.server_options('mochiweb, 3001).merge 'name: 'mochiweb_test
{ 'ok, _ } = Erlang.mochiweb_http.start options.to_list
