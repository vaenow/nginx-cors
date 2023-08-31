#!/usr/bin/env bash
# shellcheck disable=SC2086

serverName=nginx-cors-dispatcher
crAddr=ccr.ccs.tencentyun.com
version=$1
namespace=doudou


if [ "$1" == "" ]; then
    echo "NEED version param !"
    exit 1
fi

##################### make DOCKER
# npm run build:prod
# mkdir dist
# # cp default.conf dist/
# # cp Dockerfile dist/
# # cp "Privacy Policy - ShopClassic_files" dist/

imagename=${crAddr}/${namespace}/${serverName}:${version}

echo build...
docker build -t ${imagename} ./
echo push...
docker push ${imagename}

##################### Check docker push status
retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Error: Docker PUSH"
  exit $retVal
fi

##################### echo
echo
echo "${imagename}"


