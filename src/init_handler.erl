-module(init_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

-record(state, {}).

init(_, Req, _Opts) -> {ok, Req, #state{}}.

handle(Req, State = #state{}) ->
  N = request:get(n, Req, integer),

  Hub = spawn(hub, init, [
    lists:map(
      fun (_) -> spawn(blind, init, []) end,
      lists:seq(1, N)
    )
  ]),

  spawn(remote, init, [Hub]),

  {ok, Req3} = cowboy_req:reply(
    200,
    [{<<"content-type">>, <<"application/json">>}],
    <<"{\"status\": \"ok\"}">>,
    Req
  ),
  {ok, Req3, State}.

terminate(_Reason, _Req, _State) -> ok.
