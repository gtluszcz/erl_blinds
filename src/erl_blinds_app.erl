-module(erl_blinds_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
  run_server(),

  erl_blinds_sup:start_link().

run_server() ->
  helpers:create_server(init_listener, [
    {"/init", init_handler, []}
  ], 8082).

stop(_State) -> ok.
