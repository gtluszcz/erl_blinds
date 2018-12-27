PROJECT = erl_blinds
PROJECT_DESCRIPTION = Blinds Controller
PROJECT_VERSION = 0.1.0
DEPS = cowboy

start: all
	./_rel/erl_blinds_release/bin/erl_blinds_release-1 console

include erlang.mk
