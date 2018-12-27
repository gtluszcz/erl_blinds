-module(hub).

-export([init/1]).

init(Blinds) ->
  ets:new(hub, [set, named_table]),
  ets:insert(hub, {blinds, Blinds}),
  listen().

listen() ->
  receive
    {Action, Index, ok} -> send_to_blind(Action, Index), listen()
  end.

send_to_blind(Action, Index) ->
  [{blinds, Blinds}] = ets:lookup(hub, blinds),
  lists:nth(Index, Blinds) ! {Action, ok}.
