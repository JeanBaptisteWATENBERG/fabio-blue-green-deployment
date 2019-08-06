FROM tomcat:8.5.43-jdk13-openjdk-oracle

COPY target/simple-service-war.war webapps/rest.war
COPY start.sh ./start.sh
COPY consul-register.json ./consul-register.json
COPY envsubst ./envsubst
COPY server.xml ./conf/server.xml
RUN chmod +x start.sh envsubst

ENTRYPOINT exec ./start.sh