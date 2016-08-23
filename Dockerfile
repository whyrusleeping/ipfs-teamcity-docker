FROM golang:1.7

RUN mkdir /teamcity
WORKDIR /teamcity

RUN useradd runner
RUN chown -R runner:runner /teamcity
RUN mkdir /home/runner
RUN chown -R runner:runner /home/runner

#RUN pacman --noconfirm -S go nodejs wget jre8-openjdk unzip make jq openbsd-netcat npm chromium firefox xorg-server-xvfb
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get update
RUN apt-get -y install unzip jq netcat-openbsd build-essential nodejs
RUN apt-get -y install default-jre-headless



#ADD xvfb-chromium /usr/bin/xvfb-chromium
#RUN ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome
#RUN ln -s /usr/bin/xvfb-chromium /usr/bin/chromium-browser

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
