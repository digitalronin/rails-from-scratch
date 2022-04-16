FROM ruby:3-alpine

RUN apk add \
  bash \
  build-base \
  git \
  postgresql-client \
  postgresql-dev \
  tzdata

RUN gem install pg rails rspec

WORKDIR /app