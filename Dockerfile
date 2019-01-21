# イメージ容量削減のため、Alpineベースとしてhttps://blog.kasei-san.com/entry/2018/03/11/002752を参考に作成
FROM ruby:2.5.3-alpine

ENV APP_ROOT /usr/src/moment
WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN apk upgrade --no-cache && \
    apk add --update --no-cache \
      postgresql-client \
      nodejs \
      tzdata && \
    apk add --update --no-cache --virtual=build-dependencies \
      build-base \
      curl-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev \
      ruby-dev \
      yaml-dev \
      zlib-dev && \
    gem install bundler && \
    bundle install -j4 && \
    apk del build-dependencies

COPY . $APP_ROOT
