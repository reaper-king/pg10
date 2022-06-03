# Postgresql version 10 with temporal_tables Extension 
Building a docker image for Postgresql version 10.
This installs and enables the temporal_tables extention. 


`docker build -t imagename:tag`

`docker run -d -e POSTGRES_PASSWORD=mypassword storsys/pg10:main`
