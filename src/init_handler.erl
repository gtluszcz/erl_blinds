-module(init_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

init(_, Req, _Opts) -> {ok, Req, #{}}.

handle(Req, _) ->
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

terminate(_Reason, _Req, _State) -> ok.
