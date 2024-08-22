# caddy-docker-azuredns
https://hub.docker.com/_/caddy

Adding custom Caddy modules

Caddy is extendable through the use of "modules". See https://caddyserver.com/docs/extending-caddy⁠ for full details. You can find a list of available modules on the Caddy website's download page⁠.

You can use the :builder image as a short-cut to building a new Caddy binary:
```Dockerfile
FROM caddy:<version>-builder AS builder

RUN xcaddy build \
    --with github.com/caddyserver/nginx-adapter \
    --with github.com/hairyhenderson/caddy-teapot-module@v0.0.3-0

FROM caddy:<version>

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
```
Note the second FROM instruction - this produces a much smaller image by simply overlaying the newly-built binary on top of the regular caddy image.

The xcaddy⁠ tool is used to build a new Caddy entrypoint⁠, with the provided modules. You can specify just a module name, or a name with a version (separated by @). You can also specify a specific version (can be a version tag or commit hash) of Caddy to build from. Read more about xcaddy usage⁠.

Note that the "standard" Caddy modules (github.com/caddyserver/caddy/master/modules/standard⁠) are always included.
