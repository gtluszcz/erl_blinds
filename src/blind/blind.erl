-module(blind).

-define(BLIND_HEIGHT, 100).

-export([init/0]).

name() -> list_to_atom("blind" ++ pid_to_list(self())).

init() ->
  ets:new(name(), [set, named_table]),
  ets:insert(name(), [{height, 0}, {movement, 0}]),
  timer:send_interval(200, self(), {move, ok}),
  listen().

listen() ->
  receive
    {up, ok} -> set_movement(1), listen();
    {down, ok} -> set_movement(-1), listen();
    {stop, ok} -> set_movement(0), listen();
    {move, ok} -> move(), listen();
    {TargetLevel, ok} -> void; %% @TODO: Implement moving to the target level
    {level, Pid, ok} -> Pid ! {level, level(), ok}, listen()
  end.

level() ->
  [{height, Height}] = ets:lookup(name(), height),
  Height.

set_movement(By) ->
  ets:insert(name(), {movement, By}).

move() ->
  [{movement, By}] = ets:lookup(name(), movement),
  [{height, Height}] = ets:lookup(name(), height),
  move(By, Height).

move(By, Height) when Height + By >= 0 andalso Height + By =< ?BLIND_HEIGHT ->
  ets:insert(name(), {height, Height + By});
move(_, _) -> void.
