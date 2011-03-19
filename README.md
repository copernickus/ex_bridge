# ExBridge

The goal of this project is to provide an [Elixir](https://github.com/josevalim/elixir) bridge that can interact with different Erlang webservers. It is heavily influenced by [SimpleBridge](https://github.com/nitrogen/simple_bridge).

## Running tests

As Elixir was not released yet, you need to check it out and put its `bin/` directory in your path. After that, you need to get all the dependencies running the following inside this repo:

    elixir runner.ex setup

Next, you can run tests as:

    elixir runner.ex