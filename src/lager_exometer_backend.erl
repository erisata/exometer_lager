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

-export([simple_test/0]).
-include_lib("lager/include/lager.hrl").


%%% ============================================================================
%%% Internal state of the module.
%%% ============================================================================

-record(state, {
}).



%%% ============================================================================
%%% Callbacks for gen_event.
%%% ============================================================================

%% @doc
%% Sets up state passed from sys.config.
%%
init(_) ->
    io:format("INITIALIZED"),
    State = #state{},
    {ok, State}.


%% @doc
%%
%%
handle_event({log, Message}, State) ->
    {_, _, _, Type, _Timestamp1, _Timestamps2, _Text} = Message,
    ok = exometer:update_or_create([eproc_core, lager, Type], 1, histogram, []),
    io:format("got a message: ~p", [Message]),
    {ok, State};

handle_event(Event, State) ->
    io:format("Unknown event: ~p", [Event]),
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

simple_test() ->
    lager:warning("Serious warning").

%%% ============================================================================
%%% Test cases for internal functions.
%%% ============================================================================

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

%%
%%  Check, if pickle message is created properly.
%%
create_message_test_() ->
    [
        {"test_case1",
            fun() ->
                io:format("test-case1 is running")
            end
        }
    ].



-endif.