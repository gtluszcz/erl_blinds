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

  ResponseLevels1 = lists:map(fun(X) -> get_blind_level(X) end, Blinds),
  ResponseLevels2 = lists:map(fun(X) -> lists:nth(1, io_lib:format("~p", [X])) end, ResponseLevels1),
  ResponseLevels3 = string:join(ResponseLevels2, ","),
  ResponseLevels4 = "{\"levels\": [" ++ ResponseLevels3 ++ "]}",

  {ok, Req3} = cowboy_req:reply(
    200,
    [{<<"content-type">>, <<"application/json">>}],
    list_to_binary(ResponseLevels4),
    Req
  ),
  {ok, Req3, State}.

terminate(_Reason, _Req, _State) -> ok.
