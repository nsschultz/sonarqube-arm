#!/usr/bin/env bash
set -euo pipefail
exec su-exec sonarqube \
  java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.search.javaAdditionalOpts=-Dnode.store.allow_mmap=false \
  -Dsonar.web.javaAdditionalOpts=-Djava.security.egd=file:/dev/./urandom