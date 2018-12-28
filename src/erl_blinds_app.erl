-module(erl_blinds_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
  run_server(),

  erl_blinds_sup:start_link().

run_server() ->
  Dispatch = cowboy_router:compile([{'_', [
    {"/init", init_handler, []}
  ]}]),
  cowboy:start_http(
    init_listener,
    100,
    [{port, 8082}],
    [{env, [{dispatch, Dispatch}]}]
  ).

stop(_State) -> ok.
