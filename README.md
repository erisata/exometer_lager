

# The exometer_lager application #

This application provides a custom lager handler, which pushes
Lager usage statistics to Exometer.

To setup this application, add it as a dependency in rebar.config.
Also, add this application to your application's `.app.src'.

To use this application, configure Lager by adding this custom handler
`lager_exometer_backend` to `sys.config` as follows:
```
{lager, [
    {handlers, [
        {lager_console_backend, info},
        {lager_exometer_backend, [{level, [debug, info]}]},
        {lager_file_backend, [{file, "error.log"}]},
        {lager_file_backend, [{file, "console.log"}, {level, info}]}
    ]}
]}
```
If you wish to push usage of all log levels, leave parameter empty:
```
{lager_exometer_backend, []}
```

Each time when `lager:Severity' invoked, a histogram in Exometer
representing specific severity type will be updated or created with value 1.

Also, this application could be integrated with exometer_graphite created by Erisata.

To try this application:
```
make deps
make
env ERL_LIBS=deps erl -pa ebin/ -config test/sys
application:ensure_all_started(exometer_lager).
lager_exometer_backend:simple_test().
```

Optional step. To check which handlers are added, run:
```
gen_event:which_handlers(lager_event).
```

## Expected usage ##
Suppose we have a application which uses Lager by invoking lager:Severity.
We want to measure how many lager:Severity been invoked. This application
will push metrics to exometer_core from which we could send metrics to
monitoring and graphing application, for example Graphite.

So, we add exometer_lager to our .app.src:
```
{application, app_name, [
    ...
    {applications, [
        kernel,
        stdlib,
        ...
        exometer_lager
    ]}
]}.
```

We add lager_exometer_backend as a lager handler:
```
{lager, [
        {handlers, [
            ...
            {lager_exometer_backend, debug}
        ]},
    ]},
```

## TODO ##
* Pass which loglevels to measure.

## Modules ##
<table width="100%" border="0" summary="list of modules">
<tr><td><a href="http://github.com/erisata/yaws_cage/blob/master/doc/lager_exometer_backend.md" class="module">lager_exometer_backend</a></td></tr></table>