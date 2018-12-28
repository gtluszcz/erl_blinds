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

  ResponseBody = helpers:pipe(Blinds, [
    fun(X) -> lists:map(fun get_blind_level/1, X) end,
    fun(X) -> lists:map(fun(Y) -> io_lib:format("~p", [Y]) end, X) end,
    fun(X) -> lists:map(fun(Y) -> lists:nth(1, Y) end, X) end,
    fun(X) -> string:join(X, ",") end,
    fun(X) -> "{\"levels\": [" ++ X ++ "]}" end,
    fun(X) -> list_to_binary(X) end
  ]),

  {ok, Req3} = cowboy_req:reply(
    200,
    [{<<"content-type">>, <<"application/json">>}],
    ResponseBody,
    Req
  ),
  {ok, Req3, State}.

terminate(_Reason, _Req, _State) -> ok.
