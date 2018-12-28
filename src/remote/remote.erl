-module(remote).

-export([init/1]).

init(Hub) ->  Dispatch = cowboy_router:compile([{'_', [
    {"/control", remote_handler, Hub}
  ]}]),
  cowboy:start_http(
    http_listener,
    100,
    [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}, {onrequest, fun(Req) -> cowboy_req:set_meta(hub, Hub, Req) end}]
  ).
