FROM alpine:3.14.5
ARG JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ARG SONAR_VERSION_ARG=9.4.0.54424
ARG SONARQUBE_HOME=/opt/sonarqube
ARG SONARQUBE_ZIP_URL=https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION_ARG}.zip
ENV PATH="/opt/java/openjdk/bin:$PATH" \
    SONAR_VERSION=$SONAR_VERSION_ARG \  
    SONARQUBE_JDBC_USERNAME=sonar-user \
    SONARQUBE_JDBC_PASSWORD=sonar-password \
    SONARQUBE_JDBC_URL=jdbc:postgresql://sonarqube-db:5432/sonar
EXPOSE 9000
WORKDIR /opt
RUN addgroup -S -g 1000 sonarqube && adduser -S -D -u 1000 -G sonarqube sonarqube
RUN set -eux && \
    apk add --no-cache bash su-exec ttf-dejavu openjdk11-jre && \
    apk add --no-cache --virtual build-dependencies gnupg unzip curl && \
    echo "networkaddress.cache.ttl=5" >> "${JAVA_HOME}/conf/security/java.security" && \
    sed --in-place --expression="s?securerandom.source=file:/dev/random?securerandom.source=file:/dev/urandom?g" "${JAVA_HOME}/conf/security/java.security" && \
    for server in $(shuf -e hkps://keys.openpgp.org \
                            hkps://keyserver.ubuntu.com) ; do \
        gpg --batch --keyserver "${server}" --recv-keys 679F1EE92B19609DE816FDE81DB198F93525EC1A && break || : ; \
    done && \
    curl --fail --location --output sonarqube.zip --silent --show-error "${SONARQUBE_ZIP_URL}" && \
    curl --fail --location --output sonarqube.zip.asc --silent --show-error "${SONARQUBE_ZIP_URL}.asc" && \
    gpg --batch --verify sonarqube.zip.asc sonarqube.zip && \
    unzip -q sonarqube.zip && \
    mv "sonarqube-${SONAR_VERSION}" sonarqube && \
    chown -R sonarqube:sonarqube ${SONARQUBE_HOME} && \
    chmod -R 700 "${SONARQUBE_HOME}/data" "${SONARQUBE_HOME}/extensions" "${SONARQUBE_HOME}/logs" "${SONARQUBE_HOME}/temp" && \
    apk del --purge build-dependencies && \
    rm sonarqube.zip* && \
    rm -rf ${SONARQUBE_HOME}/bin/*
WORKDIR $SONARQUBE_HOME
COPY --chown=sonarqube:sonarqube run.sh ${SONARQUBE_HOME}/bin/
RUN chmod -R 777 ${SONARQUBE_HOME}/bin/
CMD ["/opt/sonarqube/bin/run.sh"]