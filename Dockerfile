# Base image
FROM mongo:3.3

MAINTAINER Paulo Silva (pmgsilva@dei.uc.pt) University of Coimbra & Eduardo Morais (eduardo.morais@gmail.com)

RUN apt-get update && apt-get -y install nano bash apt-utils sudo lftp python3

#ADD ./data /data/db
#ADD ./certs /certs

COPY ./db_scripts /db_scripts
COPY ./dump /dump
COPY ./certs /certs

VOLUME ["/data/db"]

EXPOSE 27017

#RUN --smallfiles --rest

#RUN chmod +x db_scripts/create_aaadb.sh && ./db_scripts/create_aaadb.sh
RUN python3 db_scripts/create_mongo_user.py

#ENTRYPOINT mongod --smallfiles --rest --port 27017 --dbpath /data/db
ENTRYPOINT mongod --port 27017 --clusterAuthMode x509 --sslMode requireSSL --sslPEMKeyFile /certs/mongo_crt.pem --sslCAFile /certs/root_ca.pem --dbpath /data/db
