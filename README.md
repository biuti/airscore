# Airscore flask Docker image
Dockerfile to create base Airscore Python / Flask environment container.

Based on [Python Repository](https://hub.docker.com/_/python).

Automatically builds new versions on [**Docker Hub Repository**](https://hub.docker.com/r/biuti/airscore).

Uses:
- *port 5000* for web
- *port 1220* for ssh

A host volume should be associated to */app* path. A .ssh folder will be created.

Public key for ssh access will be created (if not already present) in .ssh/etc folder.

To use Docker Hub image for ssh access:

*docker run \[parameters\] --name \[container name\] -p 1220:1220 -v \[local folder\]:/app biuti/airscore:latest*

For example, to run the container detached from terminal, named airscore_env, in local /docker/airscore folder:

*docker run -dit --name airscore_env -p 1220:1220 -v /docker/airscore:/app biuti/airscore:latest*

To be able to get access through ssh, you'll need to grab *ssh_host_rsa_key* file from \[local folder\]/.ssh/etc and use it as identity key.

