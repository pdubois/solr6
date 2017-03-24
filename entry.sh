#!/bin/bash
# trap SIGTERM and gracefully stops search service
trap '/opt/alfresco-search-services/solr/bin/solr stop;exit 0' SIGTERM
set -e

#  /opt/alfresco-search-services/solrhome
#  checking if /opt/alfresco-search-services/solrhome/alfresco
if [ ! -d /opt/alfresco-search-services/solrhome/alfresco ]; then
   /opt/alfresco-search-services/solr/bin/solr start -force -a "-Dcreate.alfresco.defaults=alfresco,archive"
   sync
   sleep 10
   sync;
   /opt/alfresco-search-services/solr/bin/solr stop
# empty the index 
#   rm  /opt/alfresco-search-services/solrhome/alfresco/index/*
#   rm  /opt/alfresco-search-services/solrhome/archive/index/*
   name="alfresco.host"
   sed -i "/opt/alfresco-search-services/solrhome/archive/conf/solrcore.properties" -e "s/$name=.*/$name=$ALFRESCO_HOST/g"
   sed -i "/opt/alfresco-search-services/solrhome/alfresco/conf/solrcore.properties" -e "s/$name=.*/$name=$ALFRESCO_HOST/g"
fi

# starting the server
/opt/alfresco-search-services/solr/bin/solr start -force

# loop so container does not exit
while true;do sleep 5;done;
