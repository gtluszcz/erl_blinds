-module(hub).

-export([init/1]).

init(Blinds) ->
  ets:new(hub, [set, named_table]),
  ets:insert(hub, {blinds, Blinds}),
  run_server(Blinds),
  listen().

listen() ->
  receive
    {Action, Index, ok} -> send_to_blind(Action, Index), listen()
  end.

send_to_blind(Action, Index) ->
  [{blinds, Blinds}] = ets:lookup(hub, blinds),
  lists:nth(Index, Blinds) ! {Action, ok}.

run_server(Blinds) ->
  helpers:create_server(hub_listener, [
    {"/status", status_handler, []}
  ], 8081, [{onrequest, fun(Req) -> cowboy_req:set_meta(blinds, Blinds, Req) end}]).
