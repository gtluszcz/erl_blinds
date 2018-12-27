-module(erl_blinds_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
  Blind1 = spawn(blind, init, []),
  Blind2 = spawn(blind, init, []),

  Hub = spawn(hub, init, [[Blind1, Blind2]]),

  Remote = spawn(remote, init, [Hub]),

  Dispatch = cowboy_router:compile([{'_', [
    {"/control", remote_handler, []}
  ]}]),
  cowboy:start_http(
    http_listener,
    100,
    [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  erl_blinds_sup:start_link().

stop(_State) -> ok.
