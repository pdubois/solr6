FROM ubuntu
MAINTAINER Philippe Dubois 
ENV DEBIAN_FRONTEND noninteractive
RUN   apt-get update && apt-get install -y --no-install-recommends ubuntu-desktop && apt-get update && apt-get install -y wget && wget https://sourceforge.net/projects/alfresco/files/Alfresco%20201707%20Community/alfresco-search-services-1.1.0.zip && unzip  alfresco-search-services-1.1.0.zip && mv alfresco-search-services /opt
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
ENV myName="John Doe"
RUN   chmod +x /entry.sh
# set default value for -Xmx and -Xms default values
ENV XMX=2048 XMS=2048
# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/entry.sh"]

