FROM arm32v6/alpine:3.7

LABEL maintainer="Benoît Vézina <benoit@xtremxpertcom>"

ENV DEBUG=false \
    DOCKER_GEN_VERSION=0.7.4 \
    DOCKER_HOST=unix:///var/run/docker.sock

# Install packages required by the image
RUN apk add --update \
        bash \
        ca-certificates \
        curl \
        jq \
        openssl \
    && rm /var/cache/apk/*

# Install docker-gen
RUN curl -L https://github.com/jwilder/docker-gen/releases/download/${DOCKER_GEN_VERSION}/docker-gen-linux-armhf-${DOCKER_GEN_VERSION}.tar.gz \
    | tar -C /usr/local/bin -xz

# Install Cert Bot instead of simp_le
#COPY /install_simp_le.sh /app/install_simp_le.sh
#RUN chmod +rx /app/install_simp_le.sh && sync && /app/install_simp_le.sh && rm -f /app/install_simp_le.sh

COPY /app/ /app/

WORKDIR /app

ENTRYPOINT [ "/bin/bash", "/app/entrypoint.sh" ]
CMD [ "/bin/bash", "/app/start.sh" ]
