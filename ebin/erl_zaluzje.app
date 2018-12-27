{application, 'erl_blinds', [
    {description, "New project"},
    {vsn, "0.1.0"},
    {modules, ['erl_blinds_app','erl_blinds_sup','hello_handler']},
    {registered, [erl_blinds_sup]},
    {applications, [kernel,stdlib,cowboy]},
    {mod, {erl_blinds_app, []}},
    {env, []}
]}.
