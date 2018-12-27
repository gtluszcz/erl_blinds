-module(test).

-export([main/0]).

main() ->
  Blind1 = spawn(blind, init, []),
  Blind2 = spawn(blind, init, []),
  Hub = spawn(hub, init, [[Blind1, Blind2]]),
  Hub ! {up, 1, ok}.
  % Blind1 ! {up, ok},
  % Blind2 ! {down, ok},
  % timer:send_after(2000, Blind1, {down, ok}),
  % ok.
