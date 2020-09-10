# Greenbone Vulnerability Manager in Kubernetes

The goal of this project is to containerize and run [Greenbone's Vulnerability Manager](https://www.greenbone.net/en/community-edition/) whole stack in Kubernetes, which includes:

* GVM Base Libraries ([gvm-libs](https://github.com/greenbone/gvm-libs))
* Greenbone Security Assistant ([gsad](https://github.com/greenbone/gsa))
* Greenbone Vulnerability Manager ([gvmd](https://github.com/greenbone/gvmd))
* Open Scanner Protocol Base Class ([ospd](https://github.com/greenbone/ospd))
* OpenVAS ([openvas](https://github.com/greenbone/openvas))
* Open Scanner Protocol implementation for OpenVAS ([ospd-openvas](https://github.com/greenbone/ospd-openvas))

Since GVM depends on Postgres and needs specific libraries installed with GVM's own Postgres plugin, a Docker image for Postgres containing GVM has also been made available.

You can find all docker images in [Dockerhub](https://hub.docker.com/u/aleksanderllada).

## Architecture

GVM has basically three components:

* `gvmd` - The actual platform for managing vulnerabilities, which requires a Postgres installation.
* `gsad` - A web UI which makes it a lot easier to operate GVM and visualize security reports.
* `ospd-openvas` - An Open Scanner Protocol server implementation for OpenVAS, which runs the actual vulnerability scans. It relies on Redis to temporarily store the results of scans.

What's "complicated about" `gvmd` and `ospd-openvas` is that both of them rely on socket connections to communicate with Postgres and Redis respectively, rather than on TCP connections. Because of that, `gvmd` must run in the same machine as Postgres, and `ospd-openvas` must run in the same machine as Redis. Although there might be hacky workarounds, these components have been designed this way with security concerns in mind.

A good solution is to have `gvmd` and Postgres run in the same pod in Kubernetes, allowing them to share sockets through an emptyDir volume. The same goes for `ospd-openvas` and Redis. 

The same principle can be applied running all containers locally, using shared volumes.
