-module(remote_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

init(_, Req, _Opts) -> {ok, Req, #{}}.

handlePost(Req) ->
  {Hub, _} = cowboy_req:meta(hub, Req),

  Index = request:get(index, Req, atom),
  Action = request:get(action, Req, atom),

  case Index of
    all -> Hub ! {Action, all, ok};
    _ -> Hub ! {Action, request:get(index, Req, integer), ok}
  end,

  helpers:json_ok_response(Req).

handle(Req, _) ->
  case request:method(Req) of
    post -> handlePost(Req);
    options -> helpers:json_response(Req, "", 204);
    _ -> helpers:json_response(Req, "{\"status\": \"Method not supported\"}", 500)
  end.

terminate(_Reason, _Req, _State) -> ok.
