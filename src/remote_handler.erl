-module(remote_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

-record(state, {}).

init(_, Req, _Opts) -> {ok, Req, #state{}}.

handle_change(Index, Action) ->
  io:format(">>>>>> ~p ~p ~n", [Index, Action]).

handle(Req, State = #state{}) ->
  {ok, KeyValues, _} = cowboy_req:body_qs(Req),
  {_, Index} = lists:keyfind(<<"index">>, 1, KeyValues),
  {_, Action} = lists:keyfind(<<"action">>, 1, KeyValues),
  handle_change(Index, Action),
  {ok, Req3} = cowboy_req:reply(
    200,
    [{<<"content-type">>, <<"application/json">>}],
    <<"{\"status\": \"ok\"}">>,
    Req
  ),
  {ok, Req3, State}.

terminate(_Reason, _Req, _State) -> ok.
