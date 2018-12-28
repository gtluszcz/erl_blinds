-module(blind).

-define(BLIND_HEIGHT, 100).

-export([init/0]).

name() -> list_to_atom("blind" ++ pid_to_list(self())).

init() ->
  ets:new(name(), [set, named_table]),
  ets:insert(name(), [{height, 0}, {target, 0}]),
  timer:send_interval(200, self(), {move, ok}),
  listen().

listen() ->
  receive
    {up, ok} -> set_target(100), listen();
    {down, ok} -> set_target(0), listen();
    {stop, ok} -> set_target_to_current(), listen();
    {move, ok} -> move(), listen();
    {TargetLevel, ok} -> set_target(TargetLevel), listen();
    {level, Pid, ok} -> Pid ! {level, level(), ok}, listen()
  end.

level() ->
  [{height, Height}] = ets:lookup(name(), height),
  Height.

set_target_to_current() ->
  [{target, TargetLevel}] = ets:lookup(name(), target),
  set_target(TargetLevel).

set_target(TargetLevel) ->
  ets:insert(name(), {target, TargetLevel}).

move() ->
  [{target, TargetLevel}] = ets:lookup(name(), target),
  [{height, Height}] = ets:lookup(name(), height),
  move(TargetLevel, Height).

move(TargetLevel, Height) when Height > TargetLevel ->
  ets:insert(name(), {height, Height - 1});
move(TargetLevel, Height) when Height < TargetLevel ->
  ets:insert(name(), {height, Height + 1});
move(_, _) -> void.
