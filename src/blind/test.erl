-module(test).

-export([main/0]).

main() ->
    Blind1 = spawn(blind, init, []),
    Blind2 = spawn(blind, init, []),
    timer:send_interval(1000, Blind1, {up, ok}),
    timer:send_interval(1000, Blind2, {down, ok}),
    ok.

%   Hub = spawn(?MODULE, hub, [Blind]),
%   spawn(?MODULE, remote, [Hub, 10]).

