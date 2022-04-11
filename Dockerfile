# Download Docker Gen
FROM --platform=$BUILDPLATFORM alpine as docker-gen
ARG DOCKER_GEN_VERSION=0.7.7
ARG TARGETARCH
RUN echo "Downloading Docker Gen $DOCKER_GEN_VERSION for $TARGETARCH" \
 && wget --quiet https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-$TARGETARCH-$DOCKER_GEN_VERSION.tar.gz -O /docker-gen.tar.gz

# Download Forego
FROM --platform=$TARGETPLATFORM golang as forego
RUN go install github.com/nginx-proxy/forego@main

FROM phpmyadmin:5

MAINTAINER Elze Kool <e.kool@kooldevelopment.nl>

# Install Forego
COPY --from=forego /go/bin/forego /usr/local/bin/forego

# Install Docker Gen
COPY --from=docker-gen /docker-gen.tar.gz /docker-gen.tar.gz
RUN tar -C /usr/local/bin -xvzf /docker-gen.tar.gz \
 && rm /docker-gen.tar.gz

RUN mv /docker-entrypoint.sh /docker-entrypoint-pma.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod u+rwx /docker-entrypoint.sh

COPY Procfile /Procfile
COPY pma-config.tmpl /pma-config.tmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["forego", "start", "-r", "-f", "/Procfile"]
