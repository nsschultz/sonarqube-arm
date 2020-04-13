FROM openjdk:8-jre-alpine
ARG SONAR_VERSION_ARG
ENV SONAR_VERSION=$SONAR_VERSION_ARG \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar-user \
    SONARQUBE_JDBC_PASSWORD=sonar-password \
    SONARQUBE_JDBC_URL=jdbc:postgresql://sonarqube-db:5432/sonar
EXPOSE 9000
WORKDIR /opt
RUN addgroup -S sonarqube && adduser -S -G sonarqube sonarqube
RUN set -x && \
    apk add --no-cache bash su-exec wget && \
    apk add --no-cache --virtual .build-deps gnupg unzip libressl && \
    wget -O sonarqube.zip --no-verbose https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-$SONAR_VERSION sonarqube && \
    chown -R sonarqube:sonarqube sonarqube && \
    apk del .build-deps && \
    rm sonarqube.zip* && \
    rm -rf $SONARQUBE_HOME/bin/*
#VOLUME "$SONARQUBE_HOME/data"
WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
RUN chmod +x $SONARQUBE_HOME/bin/run.sh
ENTRYPOINT ["./bin/run.sh"]