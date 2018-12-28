-module(request).

-export([get/3]).

get(Key, Req) ->
  {ok, KeyValues, _} = cowboy_req:body_qs(Req),
  {_, Value} = lists:keyfind(list_to_binary(atom_to_list(Key)), 1, KeyValues),
  Value.

get(Key, Req, integer) ->
  list_to_integer(binary_to_list(get(Key, Req)));
get(Key, Req, atom) ->
  list_to_atom(binary_to_list(get(Key, Req))).
