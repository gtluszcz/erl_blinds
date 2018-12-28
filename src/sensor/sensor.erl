-module(sensor).

-export([init/1]).

init(Hub) ->
  ets:new(sensor, [set, named_table]),
  ets:insert(sensor, {sun, 50}),
  timer:send_interval(500, send_to_hub, [Hub]).

send_to_hub(Hub) ->
  Level = set_random_sun(),
  Hub ! {Level, sun, ok}.

set_random_sun() ->
  [{sun, Level}] = ets:lookup(sensor, sun),
  Diff = (rand:uniform() - 0.5) * 10,
  set_random_sun(Diff + Level).
set_random_sun(Level) when Level > 100 ->
  set_random_sun(100);
set_random_sun(Level) when Level < 0 ->
  set_random_sun(0);
set_random_sun(Level) ->
  ets:insert(sensor, {sun, Level}),
  Level.
