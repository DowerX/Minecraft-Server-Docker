FROM freemanliu/openjre

ARG TYPE=release
ENV TY=$TYPE
ENV JS=https://launchermeta.mojang.com/mc/game/version_manifest.json

RUN apk add curl jq
RUN mkdir /minecraft; cd /minecraft

RUN VER="$(curl -fsSL $JS | jq ".latest."$TY)"; \
    echo Version: $VER; \
    URL="$(curl -fsSL https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r ".versions[] | select(.id == $VER) | .url")"; \
    DL="$(curl -fsSL $URL | jq -r '.downloads.server.url')"; \
    curl $DL --output /minecraft/server.jar

RUN apk del curl jq

RUN echo eula=TRUE > /minecraft/eula.txt

WORKDIR /minecraft
ENTRYPOINT ["java", "-jar", "/minecraft/server.jar", "nogui"]

