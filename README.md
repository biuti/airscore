# Airscore flask Docker image
Dockerfile to create base Airscore Python / Flask environment container.

Based on [Python Repository](https://hub.docker.com/_/python).

Automatically builds new versions on [**Docker Hub Repository**](https://hub.docker.com/r/biuti/airscore).

Uses:
- *port 5000* for web
- *port 1220* for ssh

A host volume should be associated to */app* path. A .ssh folder will be created.

Public key for ssh access will be created (if not already present) in .ssh/etc folder.

To use Docker Hub image:

*docker run biuti/airscore:latest -p 1220:1220 -p 5000:5000 -v \<host volume>:/app*
