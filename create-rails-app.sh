#!/bin/bash

# Run this script within a ruby docker container to set up a new rails application

set -euo pipefail

main() {
  create_rails_app
  cd $PROJECT
  install_gems
  add_docker_template
  fixup_compose_yml
  expose_web_server
  add_makefile
}

create_rails_app() {
  # This uses tailwindcss-rails (so limited tailwindcss plugins), and
  # import maps for javascript, so no node/yarn/esbuild
  rails new $PROJECT --database=postgresql --css=tailwind --skip-test
}

install_gems() {
  sed -i 's/# gem "redis"/gem "redis"/' Gemfile
  sed -i 's/# gem "bcrypt"/gem "bcrypt"/' Gemfile
  bundle install
}

# This is interactive
add_docker_template() {
  rails app:template LOCATION='https://railsbytes.com/script/z5OsoB'
}

fixup_compose_yml() {
  sed -i 's#    command: bundle exec rails server.*#    working_dir: /app\n    command: bin/dev#' .dockerdev/compose.yml
}

# The default `rails server` command only listens on `localhost` in the
# development environment. We need to change it to listen on 0.0.0.0
expose_web_server() {
  sed -i 's#web: bin/rails server -p 3000#web: bin/rails server -p 3000 -b 0.0.0.0#' Procfile.dev
}

add_makefile() {
  export project_name=$(echo $PROJECT | tr -d '-' | tr -d '_')
  cat ../application-makefile.template | envsubst > makefile
}

main
