# Rails from (Docker) scratch

[This
article](https://evilmartians.com/chronicles/ruby-on-whales-docker-for-ruby-rails-development)
describes a really nice docker development environment for working on rails
applications.

But, you still need a local ruby installation if you want to **create** a new
rails project, and you need ruby and the
[dip](https://github.com/bibendi/dip#readme) gem installed to
provision/launch/shutdown the docker environment.

This project describes a process for creating and then dockerising a new rails
project without these issues.

## PRE-REQUISITES

- Docker

## USAGE

### Create rails application

Build the ruby container and launch a shell:

```
make shell
```

Then, within the ruby container shell, create your new rails application:

```
rails new [project_name] --database=postgresql --css=bootstrap --javascript=esbuild --skip-test
```

> See [this
> article](https://jasonfleetwoodboldt.com/courses/stepping-up-rails/rails-7-new-app-with-js-bundling-css-bundling/)
> for why we specify **both** `--css` and `--javascript` options.

When the command has completed, cd into the new directory:

```
cd [project_name]
```

The next few commands are all run from the rails application directory.

#### Modify package.json

As per the output, modify the default `package.json` file to look like this:

```json
{
  "name": "app",
  "private": "true",
  "scripts": {
    "build": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds",
    "build:css": "sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules"
  }
}
```

#### Uncomment gems

In the `Gemfile`, uncomment these lines:

```
# gem "redis", "~> 4.0"
...
# gem "bcrypt", "~> 3.1.7"
...
# gem "sassc-rails"
```

...then run `bundle install` to add the gems.

### Dockerise

Still within the ruby container shell, add the dockerisation template:

```
cd [project_name]
rails app:template LOCATION='https://railsbytes.com/script/z5OsoB'
```

Edit the resulting `.dockerdev/compose.yml` file, and make the following
change:

```
-    command: bundle exec rails
+    working_dir: /app
+    command: bin/dev
```

This runs a background watcher which will use `esbuild` to recreate our
javascript and css assets whenever we make a change.

### Add makefile

This is required so that we don't have to install ruby and the 'dip' gem in
order to use the docker development environment.

```
export PROJECT=$(grep application .dockerdev/compose.yml | sed 's/-.*//' | sed 's/.* //')
cat ../application-makefile.template | envsubst > makefile
```

Now **exit the container shell**, and create the docker development environment:

```
cd [project_name]
make provision
```

### Install esbuild

```
make shell
yarn add esbuild sass @hotwired/stimulus @hotwired/turbo-rails @popperjs/core bootstrap bootstrap-icons
```

Commit changes to `package.json` and

Commit code changes.

At this point, you should be able to use the docker development environment to
develop your rails application.

# TODO

- get bootstrap working
- pin ruby version with ARG
