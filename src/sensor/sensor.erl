-module(sensor).

-export([init/1, set_random_sun/0, send_to_hub/1]).

init(Hub) ->
  ets:new(sensor, [set, named_table]),
  ets:insert(sensor, {sun, 50}),
  timer:send_interval(2000,self(),{emit, ok}),
  listen(Hub).

listen(Hub) ->
    receive
        {emit, ok} -> send_to_hub(Hub), listen(Hub)
    end.

send_to_hub(Hub) ->
  Level = set_random_sun(),
  Hub ! {Level, sun, ok}.

set_random_sun() ->
    [{sun, Level}] = ets:lookup(sensor, sun),
    Diff = (rand:uniform() - 0.5) * 30,
    set_random_sun(Diff + Level).
set_random_sun(Level) when Level > 100 -> 
    set_random_sun(100);
set_random_sun(Level) when Level < 0 -> 
    set_random_sun(0);
set_random_sun(Level) ->
    ets:delete(sensor, sun),
    ets:insert(sensor, {sun, Level}),
    Level.