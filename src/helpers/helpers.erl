-module(helpers).

-export([pipe/2]).

pipe(State, []) -> State;
pipe(State, [First|Tail]) -> pipe(First(State), Tail).
