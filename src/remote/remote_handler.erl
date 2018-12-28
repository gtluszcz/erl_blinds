-module(remote_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

-record(state, {}).

init(_, Req, _Opts) -> {ok, Req, #state{}}.

handle(Req, State = #state{}) ->
  {Hub, _} = cowboy_req:meta(hub, Req),

  Index = request:get(index, Req, integer),
  Action = request:get(action, Req, atom),

  Hub ! {Action, Index, ok},

  {ok, Req3} = cowboy_req:reply(
    200,
    [{<<"content-type">>, <<"application/json">>}],
    <<"{\"status\": \"ok\"}">>,
    Req
  ),
  {ok, Req3, State}.

terminate(_Reason, _Req, _State) -> ok.
