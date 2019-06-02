FROM alpine
MAINTAINER Barry Wasdell <barrywasdell@gmail.com>

RUN apk add --no-cache \
    ca-certificates \
    curl \
    tar \
    py-pip \
    && pip install s3cmd

ENV HUGO_VERSION 0.55.6

RUN curl -sSL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz | \
    tar -v -C /usr/local/bin -xz

RUN { \
    echo '[default]'; \
    echo 'access_key=$AWS_ACCESS_KEY'; \
    echo 'secret_key=$AWS_SECRET_KEY'; \
    } > ~/.s3cfg

WORKDIR /usr/src/blog

COPY . /usr/src/blog/

CMD [ "./deploy.sh" ]
