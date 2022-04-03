#!/usr/bin/env bash
set -euo pipefail
if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi
exec java -jar lib/sonar-application-"${SONAR_VERSION}".jar -Dsonar.log.console=true "$@"