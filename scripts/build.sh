#!/usr/bin/env bash
source .env

RELEASE_VERSION=$(curl --silent "https://api.github.com/repos/tailscale/tailscale/tags" | jq -r '.[0].name')
NAME=tailscale_${RELEASE_VERSION}_${ARCH}

curl https://pkgs.tailscale.com/stable/${NAME}.tgz --output ${NAME}.tgz \
  && tar zxvf ${NAME}.tgz \
  && cp ${NAME}/tailscale apk/bin/tailscale \
  && cp ${NAME}/tailscaled apk/bin/tailscaled \
  && chmod +x apk/bin/tailscale \
  && chmod +x apk/bin/tailscaled

chmod +x ./apk/CONTROL/start-stop.sh
