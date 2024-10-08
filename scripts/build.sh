#!/usr/bin/env bash

chmod +x ./scripts/apkg-tools_py3.py

rm -rf tailscale_*.tgz
rm -rf tailscale_*.apk
rm -rf tailscale_*/
rm apk/bin/tailscale*

RELEASE_VERSION=$(curl --silent "https://api.github.com/repos/tailscale/tailscale/tags" | jq '.[] | select(.name | endswith("pre") | not)' | jq -r '.name' | head -n +1 | awk -Fv '{print $2}')
NAME=tailscale_${RELEASE_VERSION}_${ARCH}


if [[ -f ${NAME}.tgz ]]; then
	rm ${NAME}.tgz
fi

curl https://pkgs.tailscale.com/stable/${NAME}.tgz --output ${NAME}.tgz


tar -xvzf ${NAME}.tgz
cp -rf ${NAME}/tailscale apk/bin/tailscale
cp -rf ${NAME}/tailscaled apk/bin/tailscaled
chmod +x apk/bin/tailscale
chmod +x apk/bin/tailscaled

chmod +x ./apk/CONTROL/start-stop.sh
