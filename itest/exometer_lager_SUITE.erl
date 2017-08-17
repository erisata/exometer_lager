%/--------------------------------------------------------------------
%| Copyright 2017 Erisata, UAB (Ltd.)
%|
%| Licensed under the Apache License, Version 2.0 (the "License");
%| you may not use this file except in compliance with the License.
%| You may obtain a copy of the License at
%|
%|     http://www.apache.org/licenses/LICENSE-2.0
%|
%| Unless required by applicable law or agreed to in writing, software
%| distributed under the License is distributed on an "AS IS" BASIS,
%| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%| See the License for the specific language governing permissions and
%| limitations under the License.
%\--------------------------------------------------------------------

%%% @doc
%%% Common Tests for `exometer_lager_backend` module.
%%%
-module(exometer_lager_SUITE).
-compile([{parse_transform, lager_transform}]).
-export([
    all/0,
    init_per_testcase/2,
    end_per_testcase/2
]).
-export([
    test_statistics_pushing/1
]).

-define(APP, exometer_lager).
-define(DEFAULT_APP_PATH, [exometer_lager]).

%%% ============================================================================
%%% Callbacks for `common_test'
%%% ============================================================================

%%  @doc
%%  CT API.
%%
all() -> [
    test_statistics_pushing
].


%%  @doc
%%  Test case test_statistics_pushing initialization.
%%
init_per_testcase(test_statistics_pushing, Config) ->
    application:load(lager),
    application:load(exometer_core),
    {ok, Apps} = application:ensure_all_started(exometer_lager),
    [{exometer_lager_apps, Apps} | Config].


%%  @doc
%%  Test case test_statistics_pushing ending.
%%
end_per_testcase(test_statistics_pushing, _Config) ->
    ok.



%%% ============================================================================
%%% Test cases.
%%% ============================================================================

%%  @doc
%%  Check, if lager statistics are pushed to exometer.
%%  Be careful using lager:Severity as it could provide unexpected test results.
%%
test_statistics_pushing(_Config) ->
    application:ensure_all_started(exometer_lager),
    AppPath = application:get_env(?APP, app_path,
        ?DEFAULT_APP_PATH),
    %
    % These lager calls should add a metrics to exometer.
    lager:debug("TEST"),
    lager:info("TEST"),
    lager:notice("TEST"),
    lager:warning("TEST"),
    lager:error("TEST"),
    lager:critical("TEST"),
    lager:alert("TEST"),
    lager:emergency("TEST"),
    %
    timer:sleep(500),
    %
    % Check if stats created.
    Entries = exometer:find_entries(AppPath),
    StatNames = [ Name || {Name, _Type, enabled} <- Entries ],
    true = length(StatNames) > 0,
    true = lists:member(lists:append(AppPath, [lager, debug]    ), StatNames),
    true = lists:member(lists:append(AppPath, [lager, info]     ), StatNames),
    true = lists:member(lists:append(AppPath, [lager, notice]   ), StatNames),
    true = lists:member(lists:append(AppPath, [lager, warning]  ), StatNames),
    true = lists:member(lists:append(AppPath, [lager, error]    ), StatNames),
    true = lists:member(lists:append(AppPath, [lager, critical] ), StatNames),
    true = lists:member(lists:append(AppPath, [lager, alert]    ), StatNames),
    true = lists:member(lists:append(AppPath, [lager, emergency]), StatNames),
    %
    % Check, if values are ok.
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, debug]    )),
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, info]     )),
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, notice]   )),
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, warning]  )),
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, error]    )),
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, critical] )),
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, alert]    )),
    {ok, _} = exometer:get_value(lists:append(AppPath, [lager, emergency])),
    ok.


