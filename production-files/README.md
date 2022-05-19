# Production Docker Image

> WARNING: These files have not been properly optimised yet. This is just the
> first thing I could get to work.

The files in this directory provide hints for creating and troubleshooting a
production-ready docker image for your Rails+Hotwire application.

Use `Dockerfile.production` as the basis of your application's docker image
build pipeline.

Use the `compose-production.yml` file in place of `.dockerdev/compose.yml` to
run a local instance of your application in production mode.
