-module(status_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

init(_, Req, _Opts) -> {ok, Req, #{}}.

get_blind_level(Blind) ->
  Blind ! {level, self(), ok},
  receive
    {level, Level, ok} -> Level
  end.

handle(Req, _) ->
  {Blinds, _} = cowboy_req:meta(blinds, Req),

  ResponseBody = helpers:pipe(Blinds, [
    fun(X) -> lists:map(fun get_blind_level/1, X) end,
    fun(X) -> lists:map(fun(Y) -> io_lib:format("~p", [Y]) end, X) end,
    fun(X) -> lists:map(fun(Y) -> lists:nth(1, Y) end, X) end,
    fun(X) -> string:join(X, ",") end,
    fun(X) -> "{\"levels\": [" ++ X ++ "]}" end
  ]),

  helpers:json_response(Req, ResponseBody).

terminate(_Reason, _Req, _State) -> ok.
