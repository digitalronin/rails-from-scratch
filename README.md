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
rails new [project_name] --database=postgresql --skip-test
```

### Dockerise

Still within the ruby container shell, add the dockerisation template:

```
cd [project_name]
rails app:template LOCATION='https://railsbytes.com/script/z5OsoB'
```

### Add Redis (for hotwire)

TODO

### Add makefile

This is required so that we don't have to install ruby and the 'dip' gem in
order to use the docker development environment.

```
export PROJECT=$(grep application .dockerdev/compose.yml | sed 's/-.*//' | sed 's/.* //')
cat ../application-makefile.template | envsubst > makefile
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

- get bootstrap working
- pin bundler to 2.3.11 (to make the evilmartians stuff)
- pin ruby version with ARG
- ping rails version with ARG
