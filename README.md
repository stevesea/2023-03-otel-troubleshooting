# 2023-03-otel-troubleshooting

repo to demonstrate issue with missing log4j1 messages from a log4j2 app.

otel-troubleshooting-svr -- spring boot app using log4j2
clientlib -- library using log4j1

to reproduce:

```shell

# build the two maven projects inside a docker container named 'tmp'
docker build -t tmp .

# run the docker container and run the examples w/ javaagents
#   1.22.1, 1.23.0, 1.24.0
#
# NOTE: metrics and traces exporters are disabled
#       log exporter set to 'logging'
docker run --rm -it tmp
```

the output shows the issue with 1.22.1, but fixed in 1.23.0.


output from 1.22.1:
```
############
############ Using otel javaagent 1.22.1
[otel.javaagent 2023-03-17 01:13:45:914 +0000] [main] INFO io.opentelemetry.javaagent.tooling.VersionLogger - opentelemetry-javaagent - version: 1.22.1
2023-03-17T01:13:50.461Z INFO 'log message from log4j2 app' : 00000000000000000000000000000000 0000000000000000 [scopeInfo: org.stevesea.oteltroubleshootingsvr.OtelTroubleshootingSvrApplication:] {}
 INFO org.stevesea.oteltroubleshootingsvr.OtelTroubleshootingSvrApplication : log message from log4j2 app
 INFO org.stevesea.oteltroubleshootingclient : log message from log4j1 client library

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /

```

there's a log4j2 appender configured to log to console, and the `OTEL_LOGS_EXPORTER=logging` will output log events through the javaagent's JUL logging output.

Notice that the log4j2 log appears twice (logged by the app's log4j2 logger, as well as the otel `logging` exporter).
But, the log4j1 log only appears once



```

############
############ Using otel javaagent 1.23.0
[otel.javaagent 2023-03-17 01:13:52:086 +0000] [main] INFO io.opentelemetry.javaagent.tooling.VersionLogger - opentelemetry-javaagent - version: 1.23.0
2023-03-17T01:13:55.952Z INFO 'log message from log4j2 app' : 00000000000000000000000000000000 0000000000000000 [scopeInfo: org.stevesea.oteltroubleshootingsvr.OtelTroubleshootingSvrApplication:] {}
 INFO org.stevesea.oteltroubleshootingsvr.OtelTroubleshootingSvrApplication : log message from log4j2 app
2023-03-17T01:13:56.018Z INFO 'log message from log4j1 client library' : 00000000000000000000000000000000 0000000000000000 [scopeInfo: org.stevesea.oteltroubleshootingclient:] {}
 INFO org.stevesea.oteltroubleshootingclient : log message from log4j1 client library

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
```

after upgrading to 1.23.0, the problem is fixed -- both log messages appear twice.