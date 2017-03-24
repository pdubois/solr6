FROM ubuntu
MAINTAINER Philippe Dubois 
ENV DEBIAN_FRONTEND noninteractive
RUN   apt-get update && apt-get install -y --no-install-recommends ubuntu-desktop && apt-get update && apt-get install -y wget && wget https://sourceforge.net/projects/alfresco/files/Alfresco%20201702%20Community/alfresco-search-services-1.0.0.zip && unzip  alfresco-search-services-1.0.0.zip && mv alfresco-search-services /opt
#install java
RUN apt-get update
RUN apt-get install -y software-properties-common curl
RUN apt-add-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true |  debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java8-set-default libgtk2.0-0 libxtst6
RUN apt-get install -y lsof && apt-get update && apt-get install -y vim

COPY  entry.sh /
RUN   chmod +x /entry.sh
COPY  solr.in.sh .
RUN   chmod +x /solr.in.sh && mv solr.in.sh /opt/alfresco-search-services

# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/entry.sh"]

