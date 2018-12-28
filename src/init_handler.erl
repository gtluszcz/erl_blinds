-module(init_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

init(_, Req, _Opts) -> {ok, Req, #{}}.

handlePost(Req) ->
  N = request:get(n, Req, integer),

  Hub = spawn(hub, init, [
    lists:map(
      fun (_) -> spawn(blind, init, []) end,
      lists:seq(1, N)
    )
  ]),

  spawn(remote, init, [Hub]),
  spawn(sensor, init, [Hub]),

  helpers:json_ok_response(Req).

handle(Req, _) ->
  case request:method(Req) of
    post -> handlePost(Req);
    options -> helpers:json_response(Req, "", 204);
    _ -> helpers:json_response(Req, "{\"status\": \"Method not supported\"}", 500)
  end.

terminate(_Reason, _Req, _State) -> ok.
