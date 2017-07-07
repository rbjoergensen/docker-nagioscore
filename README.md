# Nagios Project
This project was to create a Nagios Core server in a docker container.
It is tested and works.

## Instructions
A guide on how to use this image.

### Clients
Requirements for running on different operating systems.

#### Windows
- NSClient++
- Allow the IP of the Docker host where the container is running to access NRPE in NSClient.
- Allow external hosts to use NRPE arguments with NSClient.

#### Linux (Tested on Ubuntu 16.04)
- Install nagios-nrpe-server
- Allow the IP of the Docker host where the container is running to access nagios-nrpe-server.
- Allow external hosts to use NRPE arguments with nagios-nrpe-server.

### Mail/Notifications

### Host Configuration
