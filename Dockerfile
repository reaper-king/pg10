FROM ubuntu:18.04


RUN  apt-get update

RUN  apt-get -y upgrade

RUN apt-get -y install wget

RUN apt-get update && apt-get install -y gnupg

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

#RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc |  apt-key add -

#RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

RUN apt-get update


RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main"> /etc/apt/sources.list.d/pgdg.list
#RUN echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" | tee /etc/apt/sources.list.d/postgresql.list

#RUN apt-get -y install libpq-dev

#RUN apt-get update && apt-get install -y software-properties-common postgresql-10 postgresql-client-10 postgresql-contrib-10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&  apt-get install -y software-properties-common  postgresql-10  postgresql-client-10 postgresql-contrib-10



#USER postgres



#RUN    /etc/init.d/postgresql start &&\
#    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
#    createdb -O docker docker

USER root

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9

RUN apt-add-repository 'deb https://repos.azul.com/zulu/deb/ stable main'

RUN apt-get update && apt-get install  -y postgresql-server-dev-10  make  pgxnclient gcc

RUN pgxn install temporal_tables

RUN apt-get remove -y postgresql-server-dev-10 make pgxnclient gcc wget && apt-get autoremove -y

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf

USER postgres

RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE EXTENSION temporal_tables;"&&\
    psql --command "ALTER SYSTEM SET max_connections = 288;" &&\
    psql --command "ALTER SYSTEM SET max_prepared_transactions  = 256;"




EXPOSE 5432

VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["/usr/lib/postgresql/10/bin/postgres", "-D", "/var/lib/postgresql/10/main", "-c", "config_file=/etc/postgresql/10/main/postgresql.conf"]
