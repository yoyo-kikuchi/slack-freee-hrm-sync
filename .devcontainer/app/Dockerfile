FROM ruby:3.3.0-alpine

ARG UID=1000
ARG GID=1000
ARG USERNAME=ruby

ENV LANG=vC.UTF-8 \
    TZ=Asia/Tokyo

RUN apk update \
    && apk add --update --no-cache \
    sudo git build-base postgresql-dev tzdata libxml2-dev libxslt-dev libgcc libstdc++ \
    && rm -rf /var/cache/apk/* \
    # Create a non-privileged user and group
    && addgroup -g ${GID} ${USERNAME} \
    && adduser -D -u ${UID} -G ${USERNAME} ${USERNAME} \
    && echo "username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ruby

RUN gem install debug

WORKDIR /workspace


