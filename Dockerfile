FROM ruby:3.1.2-alpine

RUN apk add \
  bash \
  build-base \
  git \
  postgresql-client \
  postgresql-dev \
  sqlite \
  sqlite-dev \
  tzdata \
  gettext

# This is the version of bundler used in the docker development environment
# template. This ensures that we use the same bundler version for our rails
# app, which suppresses a warning and an extra installation step.
# https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development
RUN gem install bundler --version 2.3.11

RUN gem install pg rspec

RUN gem install rails --version 7.0.2.3

WORKDIR /app
