{application, 'erl_zaluzje', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['erl_zaluzje_app','erl_zaluzje_sup','hello_handler']},
	{registered, [erl_zaluzje_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {erl_zaluzje_app, []}},
	{env, []}
]}.