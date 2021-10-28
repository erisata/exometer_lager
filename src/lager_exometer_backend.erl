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
%%% Exometer lager: creates exometer metrics out of lager outputs.
%%% To use this exometer_lager, add it as a lager handler in sys.config.
%%%
-module(lager_exometer_backend).
-behaviour(gen_event).
-compile([{parse_transform, lager_transform}]).
-export([init/1, handle_call/2, handle_event/2, handle_info/2, terminate/2, code_change/3]).

-define(APP, exometer_lager).
-define(DEFAULT_APP_PATH, [?APP]).


%%% ============================================================================
%%% Internal state of the module.
%%% ============================================================================

-record(state, {
    levels :: list()
}).



%%% ============================================================================
%%% Callbacks for gen_event.
%%% ============================================================================

%%  @doc
%%  Sets up state passed from sys.config.
%%
init([]) ->
    State = #state{levels = [debug, info, notice, warning, error, critical, alert, emergency]},
    {ok, State};

init([{level, LogLevels}]) ->
    State = #state{levels = LogLevels},
    {ok, State}.


%%  @doc
%%  Handles lager:Severity log message.
%%
handle_event({log, Message}, State = #state{levels = Levels}) ->
    {_, _, _, Type, _Timestamp1, _Timestamps2, _Text} = Message,
    case lists:member(Type, Levels) of
        true ->
            AppPath = application:get_env(?APP, app_path, ?DEFAULT_APP_PATH),
            try exometer:update_or_create(AppPath ++ [lager, Type], 1, spiral, []) of
                ok -> ok
            catch
                _:_ -> ok % Ignore the situations, when the exometer is not started yet.
            end;
        false ->
            ok
    end,
    {ok, State};

handle_event(_Event, State) ->
    {ok, State}.


%%  @doc
%%  Unused.
%%
handle_call(_Request, State) ->
    {ok, ok, State}.


%% @doc
%% Unused.
%%
handle_info(_, State) ->
    {ok, State}.


%% @doc
%% Unused.
%%
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% @doc
%% Unused.
%%
terminate(_Reason, _State) ->
    ok.


