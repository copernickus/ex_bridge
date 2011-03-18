Code.unshift_path File.expand_path("..", __FILE__)
Code.unshift_path File.expand_path("../../lib", __FILE__)

Code.require "ex_bridge"

% Configure ExUnit, no options supported yet.
ExUnit.configure {:}