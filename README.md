# solr6-alfresco


Generate a docker Ubuntu based image of alfresco-search-services-1.1.0 to be used with Alfresco Community v5.2.0. (Installation comes from here https://sourceforge.net/projects/alfresco/files/Alfresco%20201707%20Community/alfresco-search-services-1.1.0.zip and the Alfresco image it should be used with is https://github.com/pdubois/docker-alfresco) 

## Description


 The Dockerfile builds from "dockerfile/ubuntu" see https://hub.docker.com/_/ubuntu/
 
- Dockerfile defines an "ENTRYPOINT" performing following configurations when containter is started first:
	- Unzip "alfresco-search-services-1.1.0.zip" under /opt/alfresco-search-services
	- Create the default 2 cores executing ***solr start -force -a "-Dcreate.alfresco.defaults=alfresco,archive"***
	- stop seach server
	- Adjust ***alfresco.host*** in solrcore.properties of both cores to make search server to track container running Alfresco. The symbolic ip address of the Alfresco container is passed throuht*** ALFRESCO_HOST*** environment variable.
  

## To generate the image from "Dockerfile"

```
cd _folder-containing-Dockerfile_
sudo docker build -t _image-name_ .
```

Examples:

```
sudo docker build -t solr6 .
```


## To start a container using the image with alfresco

The easyest way to start the stack is to use [docker-compose](https://docs.docker.com/compose/overview/) with the following yml file:



```
version: '3'
services:
   alfresco:
       image: "pdubois/docker-alfresco:master"
       ports:
        - "8443"
       environment:
        - INITIAL_PASS=admun
        - CONTAINER_FUNCTION=tomcat
        - ALF_1=db.url.EQ.jdbc:postgresql:\/\/postgres:5432\/alfresco
        - ALF_2=db.password.EQ.mysecretpassword  
        - ALF_3=db.username.EQ.postgres
        - ALF_4=index.subsystem.name.EQ.solr6
        - ALF_5=solr.secureComms.EQ.none
        - ALF_6=solr.host.EQ.solr6
        - ALF_7=solr.port.EQ.8983
        - ALF_8=solr.port.ssl.EQ.8443
        - DB_CONTAINER_NAME=postgres
       depends_on:
        - postgres
        - solr6
   postgres:
       image: postgres:9.4.4
       environment:
        - POSTGRES_PASSWORD=mysecretpassword
   solr6: 
       image: pdubois/solr6:latest
       environment:
        - ALFRESCO_HOST=alfresco
        - XMS=2048
        - XMX=2048
```

In the example above **XMS** and **XMX** represents respectively the starting heap size and the maximum heap size.

To start the stack:

```
sudo docker-compose up
```

Note:
In the above yml example it uses a automatically build version of the [solr6 image](https://hub.docker.com/r/pdubois/solr6/) and [Alfresco](https://hub.docker.com/r/pdubois/docker-alfresco/) stored on docker hub

