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
%%%
-module(lager_exometer_backend).
-behaviour(gen_event).
-compile([{parse_transform, lager_transform}]).
-export([init/1, handle_call/2, handle_event/2, handle_info/2, terminate/2,
    code_change/3]).
-include("lager.hrl").

%%% ============================================================================
%%% Internal state of the module.
%%% ============================================================================

-record(state, {
    host                :: string(),
    port                :: integer(),
    connection_timeout  :: integer(),
    socket              :: term() | undefined,
    messages            :: list(),
    graphite_delay      :: integer()
}).

%%% ============================================================================
%%% Callbacks for gen_event.
%%% ============================================================================

%% @doc
%%
%%
init(_) ->
    lager:info("Custom lager backend (handler) initialized"),
    ok.


%% @doc
%% Initializes the reporter and starts message sending loop.
%%
handle_event({log, Message}, State) ->
    {ok, State};

handle_event(_Event, State) ->
    {ok, State}.


%% @doc
%% Unused.
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