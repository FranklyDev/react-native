#!/bin/bash
set -eo pipefail

EVOKO_BASE_DIR="${1}/app"
EVOKO_INSTALL_DIR="${EVOKO_BASE_DIR}/local_modules"

CURRENT_GIT_SHA=$(git rev-parse HEAD)
CURRENT_RELEASE_VERSION=$(node -pe "require('./package.json').version")
RELEASE_LIBRARY=react-native-${CURRENT_RELEASE_VERSION}.tgz

EVOKO_INSTALL_ARTIFACT=react-native-${CURRENT_RELEASE_VERSION}-${CURRENT_GIT_SHA}.tgz

./gradlew :ReactAndroid:installArchive
npm pack
mv ${RELEASE_LIBRARY} ${EVOKO_INSTALL_DIR}/${EVOKO_INSTALL_ARTIFACT}
rm -r ${EVOKO_BASE_DIR}/node_modules/react-native || :
cd ${EVOKO_BASE_DIR}
npm --save install file:local_modules/${EVOKO_INSTALL_ARTIFACT}
