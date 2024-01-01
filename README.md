# define42/dind

This dind(docker-in-docker) image additionally includes Podman and Buildah.

docker-compose.yml for Gitlab runner with "define42/dind" image
```
version: "3.5"

services:
  dind:
    image: define42/dind:latest
    restart: always
    privileged: true
    entrypoint: ["dockerd-entrypoint.sh", "--tls=false"]
    environment:
      DOCKER_TLS_CERTDIR: ""
    command:
      - --storage-driver=overlay2

  runner:
    restart: always
    image: registry.gitlab.com/gitlab-org/gitlab-runner:alpine
    depends_on:
      - dind
    environment:
      - DOCKER_HOST=tcp://dind:2375
    volumes:
      - ./config:/etc/gitlab-runner:z

  register-runner:
    restart: 'no'
    image: registry.gitlab.com/gitlab-org/gitlab-runner:alpine
    depends_on:
      - dind
    environment:
      - CI_SERVER_URL=<hostname>
      - REGISTRATION_TOKEN=<token from gitlab runner configuration>
    command:
      - register
      - --non-interactive
      - --locked=false
      - --name=<name of runner>
      - --executor=docker
      - --docker-image=define42/dind:latest
      - --docker-privileged=true
      - --docker-volumes=/var/run/docker.sock:/var/run/docker.sock
    volumes:
      - ./config:/etc/gitlab-runner:z

```
