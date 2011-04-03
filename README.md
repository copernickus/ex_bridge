# ExBridge

The goal of this project is to provide an [Elixir](https://github.com/josevalim/elixir) bridge that can interact with different Erlang webservers. It is heavily influenced by [SimpleBridge](https://github.com/nitrogen/simple_bridge).

## API

ExBridge has two main APIs: one for the request and other for the response object (and a websocket API is still in development). The request API is mainly for reading request information while the response contains information about the response to be returned to the client.

### Request API

* `request_method` - Returns an atom with the request method, for example `'GET`.
* `path` - Returns the request path, for example `"/foo/bar"`.
* `headers` - Returns all the headers given in the request as a Dict. Both keys and values are strings.
* `memoize!` - Returns a new object where headers and cookies are memoized.

### Response API

* `status` - Reads the currently set status code.
* `status(status)` - Sets the given *status* code.

* `headers` - Returns an object to manipulate headers:
    * `[](header)` - Reads the given *header*.
    * `merge(headers)` - Adds the given *headers* to the current set.
    * `clear` - Clears the current headers.
    * `delete(header)` - Removes the given *header* from the set.

* `cookies` - Returns an object to manipulate headers:
    * `[](key)` - Reads the cookie given by *key*.
    * `set(key, value, options := {:})` - Sets a cookie with *key*, *value* and given *options*.
    * `delete(key, options := {:})` - Removes the cookie given by *key*. Removing a cookie happens by setting its value to deleted and setting it expires date to 1970. All options given when creating a cookie must also be given when removing it.

    Cookie options can be *domain* (string), *path* (string), *expires* (datetime or string), *secure* (boolean) and *httponly* (boolean). All cookies are *httponly* by default.

* `body` - Read the currently set body.
* `body(body)` - Replaces the current body by the one given.

* `file` - Read the *filepath* currently set as response.
* `file(filepath)` - Return the file at *filepath* on respond.

* `respond` - Respond to the client using the set status, headers and body values.
* `respond(status, headers, body)` - Respond to the client using the given *status*, *headers* and *body*. It ignores any previously set value.

* `serve_file(file, headers)` - Serve the given file with headers ignoring previously set values.

## Running tests

As Elixir was not released yet, you need to check it out and put its `bin/` directory in your path. After that, you need to get all the dependencies running the following inside this repo:

    elixir runner.ex setup

Next, you can run tests as:

    elixir runner.ex