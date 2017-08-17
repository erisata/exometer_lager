

# Module lager_exometer_backend #
* [Description](#description)
* [Function Index](#index)
* [Function Details](#functions)

Exometer lager: creates exometer metrics out of lager outputs.

__Behaviours:__ [`gen_event`](gen_event.md).

<a name="description"></a>

## Description ##
To use this exometer_lager, add it as a lager handler in sys.config.
<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#code_change-3">code_change/3</a></td><td>
Unused.</td></tr><tr><td valign="top"><a href="#handle_call-2">handle_call/2</a></td><td>
Unused.</td></tr><tr><td valign="top"><a href="#handle_event-2">handle_event/2</a></td><td>
Handles lager:Severity log message.</td></tr><tr><td valign="top"><a href="#handle_info-2">handle_info/2</a></td><td>
Unused.</td></tr><tr><td valign="top"><a href="#init-1">init/1</a></td><td>
Sets up state passed from sys.config.</td></tr><tr><td valign="top"><a href="#terminate-2">terminate/2</a></td><td>
Unused.</td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="code_change-3"></a>

### code_change/3 ###

`code_change(OldVsn, State, Extra) -> any()`

Unused.

<a name="handle_call-2"></a>

### handle_call/2 ###

`handle_call(Request, State) -> any()`

Unused.

<a name="handle_event-2"></a>

### handle_event/2 ###

`handle_event(Event, State) -> any()`

Handles lager:Severity log message.

<a name="handle_info-2"></a>

### handle_info/2 ###

`handle_info(X1, State) -> any()`

Unused.

<a name="init-1"></a>

### init/1 ###

`init(X1) -> any()`

Sets up state passed from sys.config.

<a name="terminate-2"></a>

### terminate/2 ###

`terminate(Reason, State) -> any()`

Unused.

