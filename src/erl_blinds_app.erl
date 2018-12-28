-module(erl_blinds_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
  Blind1 = spawn(blind, init, []),
  Blind2 = spawn(blind, init, []),

  Hub = spawn(hub, init, [[Blind1, Blind2]]),

  spawn(remote, init, [Hub]),

  erl_blinds_sup:start_link().

stop(_State) -> ok.
