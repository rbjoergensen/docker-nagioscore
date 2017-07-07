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
In my setup I am using a bash script that sends a post to a Sendgrid API endpoint using JSON to send mail.

You can edit the sendmail.sh script to contain your own mail script if you use something else.

Just remember to edit the commands.cfg file to reflect the changes :)

### Host Configuration

Any hostfiles ending in .cfg placed in the servers folder will be loaded.

Nagios won't run and will throw an error message if there are errors in these or missing dependencies.

```
/usr/local/nagios/etc/servers
```
