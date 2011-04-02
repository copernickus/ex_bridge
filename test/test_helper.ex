Code.unshift_path File.expand_path("..", __FILE__)
Code.unshift_path File.expand_path("../../lib", __FILE__)

Code.require "ex_bridge"
Code.require "support/http_client"
Code.require "support/server_case"

% Configure ExUnit, no options supported yet.
ExUnit.configure {:}

% ASSERTION FLAG
% Flag above used in tests