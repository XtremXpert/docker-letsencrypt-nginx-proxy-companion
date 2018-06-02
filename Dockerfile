FROM arm32v6/python:2.7-alpine3.6

LABEL maintainer="Benoît Vézina <benoit@xtremxpert.com>"

ENV DEBUG=false \
    DOCKER_GEN_VERSION=0.7.4 \
    DOCKER_HOST=unix:///var/run/docker.sock

COPY /app/ /app/

# Install packages required by the image
RUN apk add --update \
        bash \
        ca-certificates \
        curl \
        jq \
        openssl \

    && apk --update add --virtual .build-dependencies \
	libffi-dev \
	openssl-dev \
	python-dev \
	py-pip \
	build-base \

    && pip install \
	certbot \
	certbot-dns-cloudflare \

    && curl -L https://github.com/jwilder/docker-gen/releases/download/${DOCKER_GEN_VERSION}/docker-gen-linux-armhf-${DOCKER_GEN_VERSION}.tar.gz \
    	| tar -C /usr/local/bin -xz \

    && rm /var/cache/apk/* \
    && apk del .build-dependencies

# Install Cert Bot instead of simp_le
#COPY /install_simp_le.sh /app/install_simp_le.sh
#RUN chmod +rx /app/install_simp_le.sh && sync && /app/install_simp_le.sh && rm -f /app/install_simp_le.sh

WORKDIR /app


ENTRYPOINT [ "/bin/bash", "/app/entrypoint.sh" ]

CMD [ "/bin/bash", "/app/start.sh" ]
