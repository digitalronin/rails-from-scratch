#!/bin/bash

# Run this script within a ruby docker container to set up a new rails application

set -euo pipefail

main() {
  create_rails_app
  cd $PROJECT
  replace_package_json
  install_gems
  add_docker_template
  fixup_compose_yml
  expose_web_server
  add_makefile
}

# See [this
# article](https://jasonfleetwoodboldt.com/courses/stepping-up-rails/rails-7-new-app-with-js-bundling-css-bundling/)
# for why we specify **both** `--css` and `--javascript` options.
create_rails_app() {
  rails new $PROJECT --database=postgresql --css=bootstrap --javascript=esbuild --skip-test
}

replace_package_json() {
  cp ../package.json .
}

install_gems() {
  sed -i 's/# gem "redis"/gem "redis"/' Gemfile
  sed -i 's/# gem "bcrypt"/gem "bcrypt"/' Gemfile
  sed -i 's/# gem "sassc-rails"/gem "sassc-rails"/' Gemfile
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
