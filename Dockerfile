FROM base/devel

RUN pacman-key --refresh-keys
RUN pacman-db-upgrade
RUN pacman --noconfirm -Syu
RUN pacman-db-upgrade

RUN mkdir /teamcity
WORKDIR /teamcity

RUN useradd runner
RUN chown -R runner:runner /teamcity
RUN mkdir /home/runner
RUN chown -R runner:runner /home/runner

RUN pacman --noconfirm -S go nodejs wget jre8-openjdk unzip make jq openbsd-netcat npm chromium

USER runner
RUN wget http://ci.i.ipfs.io:8111/update/buildAgent.zip
RUN unzip buildAgent.zip
RUN chmod +x /teamcity/bin/agent.sh
RUN chmod +x /teamcity/bin/install.sh

USER root
COPY buildAgent.properties /teamcity/conf/buildAgent.properties
RUN chown runner:runner /teamcity/conf/buildAgent.properties
USER runner

WORKDIR /teamcity/bin
RUN ./install.sh http://ci.i.ipfs.io:8111
CMD ./agent.sh run
