{application, 'erl_blinds', [
	{description, "Blinds Controller"},
	{vsn, "0.1.0"},
	{modules, ['blind','erl_blinds_app','erl_blinds_sup','helpers','hub','init_handler','remote','remote_handler','request','status_handler']},
	{registered, [erl_blinds_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {erl_blinds_app, []}},
	{env, []}
]}.