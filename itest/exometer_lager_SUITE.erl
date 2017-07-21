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
%%% Common Tests for `exometer_lager_reporter` module.
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
-define(DEFAULT_INTEGRATED_PROJECT_NAME, exometer_lager).

%%% ============================================================================
%%% Callbacks for `common_test`
%%% ============================================================================

%%  @doc
%%  CT API.
%%
all() -> [
    test_statistics_pushing
].


%%  @doc
%%  Test case test_message_sending initialization.
%%
init_per_testcase(test_statistics_pushing, Config) ->
    application:load(lager),
    application:load(exometer_core),
    {ok, Apps} = application:ensure_all_started(exometer_lager),
    [{exometer_lager_apps, Apps} | Config].


%%  @doc
%%  Test case test_message_sending ending.
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
    ProjectName = application:get_env(?APP, integrated_project_name,
        ?DEFAULT_INTEGRATED_PROJECT_NAME),
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
    Entries = exometer:find_entries([ProjectName]),
    StatNames = [ Name || {Name, _Type, enabled} <- Entries ],
    true = length(StatNames) > 0,
    true = lists:member([ProjectName, lager, debug], StatNames),
    true = lists:member([ProjectName, lager, info], StatNames),
    true = lists:member([ProjectName, lager, notice], StatNames),
    true = lists:member([ProjectName, lager, warning], StatNames),
    true = lists:member([ProjectName, lager, error], StatNames),
    true = lists:member([ProjectName, lager, critical], StatNames),
    true = lists:member([ProjectName, lager, alert], StatNames),
    true = lists:member([ProjectName, lager, emergency], StatNames),
    %
    % Check, if values are ok.
    {ok, _} = exometer:get_value([ProjectName, lager, debug]),
    {ok, _} = exometer:get_value([ProjectName, lager, info]),
    {ok, _} = exometer:get_value([ProjectName, lager, notice]),
    {ok, _} = exometer:get_value([ProjectName, lager, warning]),
    {ok, _} = exometer:get_value([ProjectName, lager, error]),
    {ok, _} = exometer:get_value([ProjectName, lager, critical]),
    {ok, _} = exometer:get_value([ProjectName, lager, alert]),
    {ok, _} = exometer:get_value([ProjectName, lager, emergency]).
