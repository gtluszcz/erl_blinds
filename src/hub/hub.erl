-module(hub).

-export([init/1]).

init(Blinds) ->
  ets:new(hub, [set, named_table]),
  ets:insert(hub, [{blinds, Blinds}, {mode, manual}]),
  run_server(Blinds),
  listen().

listen() ->
  receive
    {Mode, mode, ok} -> change_mode(Mode), listen();
    {Level, sun, ok} -> process_sun(Level), listen();
    {Action, Index, ok} -> process_remote(Action, Index), listen()
  end.

change_mode(Mode) ->
  ets:insert(hub, {mode, Mode}).

get_mode() ->
  [{mode, Mode}] = ets:lookup(hub, mode),
  Mode.

process_remote(Action, all) ->
  [{blinds, Blinds}] = ets:lookup(hub, blinds),
  Mode = get_mode(),
  lists:foreach(
    fun(Index) -> process_remote(Action, Index, Mode) end,
    lists:seq(1, length(Blinds))
  );
process_remote(Action, Index) -> process_remote(Action, Index, get_mode()).
process_remote(Action, Index, Mode) when Mode =:= manual ->
  send_to_blind_index(Action, Index);
process_remote(_, _, _) -> void.

process_sun(Level) -> process_sun(Level, get_mode()).
process_sun(Level, Mode) when Mode =:= auto ->
  send_to_all_blinds(Level);
process_sun(_, _) -> void.

send_to_all_blinds(Level) ->
  [{blinds, Blinds}] = ets:lookup(hub, blinds),
  lists:foreach(fun(Blind) -> send_to_blind(Level, Blind) end, Blinds).

send_to_blind_index(Action, Index) ->
  [{blinds, Blinds}] = ets:lookup(hub, blinds),
  send_to_blind(Action, lists:nth(Index, Blinds)).

send_to_blind(ActionOrLevel, Blind) ->
  Blind ! {ActionOrLevel, ok}.

run_server(Blinds) ->
  helpers:create_server(hub_listener, [
    {"/status", status_handler, []}
  ], 8081, [{onrequest, fun(Req) -> cowboy_req:set_meta(blinds, Blinds, Req) end}]).
