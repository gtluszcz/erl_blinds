-module(remote).

-export([init/1]).

init(Hub) -> run_server(Hub).

run_server(Hub) ->
  Dispatch = cowboy_router:compile([{'_', [
    {"/control", remote_handler, []}
  ]}]),
  cowboy:start_http(
    remote_listener,
    100,
    [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}, {onrequest, fun(Req) -> cowboy_req:set_meta(hub, Hub, Req) end}]
  ).
