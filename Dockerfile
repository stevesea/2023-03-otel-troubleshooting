FROM maven:3-eclipse-temurin-8

RUN mkdir /app
WORKDIR /app


ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v1.22.1/opentelemetry-javaagent.jar /app/otel-1.22.1.jar
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v1.23.0/opentelemetry-javaagent.jar /app/otel-1.23.0.jar
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v1.24.0/opentelemetry-javaagent.jar /app/otel-1.24.0.jar

# very dumb workaround for issues on my work laptop w/ zscaler
# this is very bad practice. don't do this.

ENV MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.resolver.transport=wagon"

RUN env | grep MAVEN
# build client lib, install it to the in-container m2 repository

COPY ./clientlib /app/clientlib
RUN cd clientlib && mvn install

COPY ./otel-troubleshooting-svr /app/otel-troubleshooting-svr
# build demo app (depending on the in-container client lib built earlier)
RUN cd otel-troubleshooting-svr && mvn package

COPY demo.sh .

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/app/demo.sh"]