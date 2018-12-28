-module(helpers).

-export([pipe/2, json_response/2, json_response/3, json_ok_response/1, create_server/3, create_server/4]).

pipe(State, []) -> State;
pipe(State, [First|Tail]) -> pipe(First(State), Tail).

json_ok_response(Req) -> json_response(Req, "{\"status\": \"ok\"}", 200).

json_response(Req, Body) -> json_response(Req, Body, 200).

json_response(Req, Body, Status) when is_list(Body) -> json_response(Req, list_to_binary(Body), Status);
json_response(Req, Body, Status) when is_binary(Body) ->
  {ok, Req_} = cowboy_req:reply(
    Status,
    [{<<"content-type">>, <<"application/json">>}],
    Body,
    Req
  ),
  {ok, Req_, #{}}.

create_server(Name, Paths, Port) -> create_server(Name, Paths, Port, []).
create_server(Name, Paths, Port, Options) ->
  Dispatch = cowboy_router:compile([{'_', Paths}]),
  cowboy:start_http(
    Name,
    100,
    [{port, Port}],
    [{env, [{dispatch, Dispatch}]}] ++ Options
  ).
