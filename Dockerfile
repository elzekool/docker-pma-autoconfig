FROM phpmyadmin/phpmyadmin:5

MAINTAINER Elze Kool <e.kool@kooldevelopment.nl>

# Install wget, go and git
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    wget golang git
    
# Install Docker Gen
ENV DOCKER_GEN_VERSION 0.7.7

RUN wget --quiet https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz -O /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

# Install Forego
RUN go get -u github.com/nginx-proxy/forego \
 && mv ~/go/bin/forego /usr/local/bin/forego

RUN mv /docker-entrypoint.sh /docker-entrypoint-pma.sh

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod u+rwx /docker-entrypoint.sh

COPY Procfile /Procfile
COPY pma-config.tmpl /pma-config.tmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["forego", "start", "-r", "-f", "/Procfile"]
