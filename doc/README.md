

# The exometer_lager application #

This application provides a custom lager handler, which pushes Lager
usage statistics to the Exometer.

To setup this application, add it as a dependency in rebar.config.
Also, add this application to your application's `.app.src`.

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

To check which handlers are added, run:
```
gen_event:which_handlers(lager_event).
```


## Modules ##


<table width="100%" border="0" summary="list of modules">
<tr><td><a href="lager_exometer_backend.md" class="module">lager_exometer_backend</a></td></tr></table>

