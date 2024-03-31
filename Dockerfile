# Build stage
FROM ruby:3.3.0-alpine as Builder

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    libxml2-dev \
    libxslt-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config set without 'development test' \
    && bundle install

COPY . .

# Execution stage
FROM ruby:3.3.0-alpine

ARG GID=1000
ARG UID=1000
ARG USERNAME=rails

ENV LANG=C.UTF-8 \
    RAILS_ENV=production \
    # ログを標準出力させる
    RAILS_LOG_TO_STDOUT=1 \
    # 静的ファイルの配信をON
    RAILS_SERVE_STATIC_FILES=true

RUN apk update \
    && apk add --update --no-cache tzdata libxml2 libxslt libpq \
    # Create a non-privileged user and group
    && addgroup -g ${GID} ${USERNAME} \
    && adduser -D -u ${UID} -G ${USERNAME} ${USERNAME}

WORKDIR /app
RUN chown $USERNAME:$USERNAME /app
COPY --from=Builder --chown=$USERNAME:$USERNAME /app /app
COPY --from=Builder --chown=$USERNAME:$USERNAME /usr/local/bundle/ /usr/local/bundle/
COPY --chown=$USERNAME:$USERNAME ./bin/docker-entrypoint /app/

USER $USERNAME

RUN chmod +x /app/docker-entrypoint.sh

ENTRYPOINT [ "./docker-entrypoint.sh" ]
EXPOSE 3000

CMD ["rails", "server", "-u", "puma", "-b", "0.0.0.0"]
