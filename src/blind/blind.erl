-module(blind).

-export([init/0]).

name() ->
    list_to_atom("blind" ++ pid_to_list(self())).

init() ->
    ets:new(name(), [set, named_table]),
    ets:insert(name(), {height, 0}),
    timer:apply_interval(1000,blind,move,name()),
    listen().

listen() ->
    receive
        {up, ok} -> move(5), level(), listen();
        {down, ok} -> move(-5), level(), listen()
    end.

level() -> 
    [{height, Height}] = ets:lookup(name(), height),
    io:format("~p ~p ~n", [name(), Height]).
   
move(By) -> 
    [{height, Height}] = ets:lookup(name(), height),
    ets:delete(name(), height),
    ets:insert(name(), {height, Height + By}).

