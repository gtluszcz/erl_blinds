-module(hub).

-export([init/1]).

init(Blinds) ->
  Dispatch = cowboy_router:compile([{'_', [
    {"/", hello_handler, []}
  ]}]),
  cowboy:start_http(my_http_listener, 100, [{port, 8080}], [{env, [{dispatch, Dispatch}]}]).
