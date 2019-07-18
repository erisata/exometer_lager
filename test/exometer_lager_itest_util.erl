%%% @private
%%% Utilites for integration tests.
%%%
-module(exometer_lager_itest_util).
-export([ensure_deps/1, ensure_deps/0]).

%%
%%
%%
ensure_deps(LogPrefix) ->
    case file:make_dir("logs") of
        ok              -> ok;
        {error, eexist} -> ok
    end,
    LagerHandlers = [
        {lager_file_backend, [
            {file,      "logs/" ++ LogPrefix ++ "_lager.log"},
            {level,     debug},
            {formatter, lager_default_formatter}
        ]},
        {lager_exometer_backend, []}
    ],
    ok = application:set_env(kernel,         error_logger,          {file, "logs/" ++ LogPrefix ++ "_kernel.log"}, [{persistent, true}]),
    ok = application:set_env(lager,          handlers,              LagerHandlers,                                 [{persistent, true}]),
    ok = application:set_env(lager,          error_logger_redirect, true,                                          [{persistent, true}]),
    ok = application:set_env(lager,          crash_log,             "logs/" ++ LogPrefix ++ "_crash.log",          [{persistent, true}]),
    {ok, _} = application:ensure_all_started(lager),
    {ok, _} = application:ensure_all_started(exometer_core),
    ok.

ensure_deps() ->
    ensure_deps("test").

