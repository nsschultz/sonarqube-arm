#!/usr/bin/env bash
set -euo pipefail
exec java -jar lib/sonar-application-"${SONAR_VERSION}".jar -Dsonar.log.console=true