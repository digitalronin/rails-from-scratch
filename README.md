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

Build the ruby container and launch a shell:

```
make shell
```

Then, within the ruby container shell, create your new rails application:

```
rails new [project_name] \
  --database=postgresql \
  --skip-test \
  --css=bootstrap
```

Still within the ruby container shell, add the dockerisation template:

```
cd [project_name]
rails app:template LOCATION='https://railsbytes.com/script/z5OsoB'
```

Now exit the container shell, and create the docker development environment:

```
cd [project_name]
dip provision
```

Commit code changes.

At this point, you should be able to use the docker development environment to
develop your rails application.

# TODO

- add instructions for how to use this without 'dip'
- pin ruby version with ARG
- ping rails version with ARG

Get this working, if necessary (no sass installed yet)
- Add "scripts": { "build:css": "sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules" } to your package.json

