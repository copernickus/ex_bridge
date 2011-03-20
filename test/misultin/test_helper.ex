Code.require File.expand_path("../../test_helper", __FILE__)
Code.require "ex_bridge/misultin"

Erlang.code.add_path $"deps/misultin/ebin"

options = RequestCase.server_options('misultin, 3002)
{ 'ok, _ } = Erlang.misultin.start_link options.to_list