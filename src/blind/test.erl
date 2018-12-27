-module(test).

-export([main/0]).

main() ->
    Blind1 = spawn(blind, init, []),
    Blind2 = spawn(blind, init, []),
    Blind1!{up, ok},
    Blind2!{down, ok},
    ok.

%   Hub = spawn(?MODULE, hub, [Blind]),
%   spawn(?MODULE, remote, [Hub, 10]).

