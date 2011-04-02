# ExBridge

The goal of this project is to provide an [Elixir](https://github.com/josevalim/elixir) bridge that can interact with different Erlang webservers. It is heavily influenced by [SimpleBridge](https://github.com/nitrogen/simple_bridge).

## API

ExBridge has two main APIs: one for the request and other for the response object (and a websocket API is still in development). The request API is mainly for reading request information while the response contains information about the response to be returned to the client.

### Request API

* `request_method()` - Returns an atom with the request method, for example `'GET`
* `path` - Returns the request path, for example `"/foo/bar"`

### Response API

* `status` - Reads the currently set status code
* `status(status)` - Sets the given *status* code

* `headers` - Reads the currently set headers
* `merge_headers(headers)` - Adds the given *headers* to the current set
* `clear_headers` - Clears the current headers set

* `body` - Read the currently set body
* `body(body)` - Replaces the current body by the one given

* `file` - Read the *filepath* currently set as response
* `file(filepath)` - Return the file at *filepath* on respond

* `respond` - Respond to the client using the set status, headers and body values
* `respond(status, headers, body)` - Respond to the client using the given *status*, *headers* and *body*. It ignores any previously set value.

* `serve_file(file, headers)` - Serve the given file with headers ignoring previously set values

## Running tests

As Elixir was not released yet, you need to check it out and put its `bin/` directory in your path. After that, you need to get all the dependencies running the following inside this repo:

    elixir runner.ex setup

Next, you can run tests as:

    elixir runner.ex