Code.require_file "../../test_helper", __FILE__
Code.prepend_path "deps/misultin/ebin"

options = ServerCase.server_options('misultin, 3002)
{ 'ok, _ } = Erlang.misultin.start_link options.to_list