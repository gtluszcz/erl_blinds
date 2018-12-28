-module(remote).

-export([init/1]).

init(Hub) -> run_server(Hub).

run_server(Hub) ->
  helpers:create_server(remote_listener, [
    {"/control", remote_handler, []}
  ], 8080, [{onrequest, fun(Req) -> cowboy_req:set_meta(hub, Hub, Req) end}]).
