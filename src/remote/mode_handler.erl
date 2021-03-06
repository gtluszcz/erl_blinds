-module(mode_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

init(_, Req, _Opts) -> {ok, Req, #{}}.

handle(Req, _) ->
  {Hub, _} = cowboy_req:meta(hub, Req),

  Mode = request:get(mode, Req, atom),

  Hub ! {Mode, mode, ok},

  helpers:json_ok_response(Req).

terminate(_Reason, _Req, _State) -> ok.
