-module(status_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

-record(state, {}).

init(_, Req, _Opts) -> {ok, Req, #state{}}.

get_blind_level(Blind) ->
  Blind ! {level, self(), ok},
  receive
    {level, Level, ok} -> Level
  end.

handle(Req, State = #state{}) ->
  {Blinds, _} = cowboy_req:meta(blinds, Req),

  X1 = lists:map(fun get_blind_level/1, Blinds),
  X2 = lists:map(fun(X) -> io_lib:format("~p", [X]) end, X1),
  X3 = lists:map(fun(X) -> lists:nth(1, X) end, X2),
  X4 = string:join(X3, ","),
  X5 = "{\"levels\": [" ++ X4 ++ "]}",
  X6 = list_to_binary(X5),

  {ok, Req3} = cowboy_req:reply(
    200,
    [{<<"content-type">>, <<"application/json">>}],
    X6,
    Req
  ),
  {ok, Req3, State}.

terminate(_Reason, _Req, _State) -> ok.
