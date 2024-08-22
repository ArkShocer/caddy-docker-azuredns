# caddy-docker-azuredns
From https://hub.docker.com/_/caddy

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

## Configuration
Setup the Docker container with the correct environment variables
```Dockerfile
docker run -it --name caddy \
    -p 80:80 \
    -p 443:443 \
    -v caddy_data:/data \
    -v caddy_config:/config \
    -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
    -e AZURE_TENANT_ID=00000000-0000-0000-0000-000000000000 \
    -e AZURE_CLIENT_ID=00000000-0000-0000-0000-000000000000 \
    -e AZURE_CLIENT_SECRET=CLIENT_SECRET \
    -e AZURE_SUBSCRIPTION_ID=00000000-0000-0000-0000-000000000000 \
    -e AZURE_RESOURCE_GROUP_NAME=AZURE_RG \
    -e ACME_AGREE=true \
    ghcr.io/arkshocer/caddy-docker-azuredns:latest
```
Set the `Caddyfile` accordingly
```bash
 tls {
   dns azure {
     tenant_id {$AZURE_TENANT_ID}
     client_id {$AZURE_CLIENT_ID}
     client_secret {$AZURE_CLIENT_SECRET}
     subscription_id {$AZURE_SUBSCRIPTION_ID}
     resource_group_name {$AZURE_RESOURCE_GROUP_NAME}
   }
 }
```
