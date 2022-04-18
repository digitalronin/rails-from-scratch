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
PROJECT=foo-bar ./create-rails-app.sh
```

When the command has completed, **exit the container shell**, and cd into the new directory:

```
cd [project_name]
make provision
```

Commit code changes.

At this point, you should be able to use the docker development environment to
develop your rails application.

See the `makefile` for details on how to start/stop the environment, get a
shell or rails console prompt, etc.

### Hotwire

To get hotwire working in development, edit the development section of
`config/cable.yml` as follows:

```
development:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
```

# TODO

- add rspec
