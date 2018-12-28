-module(blind).

-include("../constants.hrl").

-export([init/0]).

name() -> list_to_atom("blind" ++ pid_to_list(self())).

init() ->
  ets:new(name(), [set, named_table]),
  ets:insert(name(), [{height, 0}, {movement, 0}]),
  timer:send_interval(200, self(), {move, ok}),
  % run_server(),
  listen().

listen() ->
  receive
    {up, ok} -> set_movement(1), listen();
    {down, ok} -> set_movement(-1), listen();
    {stop, ok} -> set_movement(0), listen();
    {move, ok} -> move(), level(), listen()
  end.

level() ->
  [{height, Height}] = ets:lookup(name(), height),
  io:format("~p ~p ~n", [name(), Height]).

set_movement(By) ->
  ets:delete(name(), movement),
  ets:insert(name(), {movement, By}).

move() ->
  [{movement, By}] = ets:lookup(name(), movement),
  [{height, Height}] = ets:lookup(name(), height),
  move(By, Height).

move(By, Height) when By < 0 andalso Height > 0 ->
  ets:delete(name(), height),
  ets:insert(name(), {height, Height + By});
move(By, Height) when By > 0 andalso Height < ?BLIND_HEIGHT ->
  ets:delete(name(), height),
  ets:insert(name(), {height, Height + By});
move(_, _) -> void.

% run_server() -> Dispatch = cowboy_router:compile([{'_', [
%     {"/status", status_handler, [level()]}
%   ]}]),
%   cowboy:start_http(
%     http_listener,
%     100,
%     [{port, 8081}],
%     [{env, [{dispatch, Dispatch}]}]
%   ).
