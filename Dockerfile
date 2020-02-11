FROM ubuntu:18.04
MAINTAINER Marco Pantaleoni <marco.pantaleoni@gmail.com>

RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends tzdata software-properties-common

RUN dpkg-reconfigure -f noninteractive tzdata &&\
dpkg --add-architecture i386 && \
add-apt-repository multiverse -y && \
apt-get update -y && \
apt-get dist-upgrade -y && \
apt-get install wine32 wine64 lib32gcc1 -y
 

# Install packages
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends wget curl rsync netcat mg vim bzip2 zip unzip && \
    apt-get install -y --no-install-recommends libx11-6 libxcb1 libxau6 && \
    apt-get install -y --no-install-recommends lxde tightvncserver xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get install -y --no-install-recommends python-pip python-dev python-qt4 && \
    apt-get install -y --no-install-recommends libssl-dev steam && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/
ENV VNCPASSWORD password
RUN mkdir -p /root/.vnc
COPY xstartup /root/.vnc/
RUN chmod a+x /root/.vnc/xstartup
RUN touch /root/.vnc/passwd
RUN /bin/bash -c "echo -e '$VNCPASSWORD\n$VNCPASSWORD\nn' | vncpasswd" > /root/.vnc/passwd
RUN chmod 400 /root/.vnc/passwd
RUN chmod go-rwx /root/.vnc
RUN touch /root/.Xauthority

COPY start-vncserver.sh /root/
RUN chmod a+x /root/start-vncserver.sh && \
apt-add-repository multiverse && apt-get update && \
apt-get install q4wine -y && \
mkdir -p /opt/steamcmd &&\
    cd /opt/steamcmd &&\
    curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xvz

RUN echo "mycontainer" > /etc/hostname
RUN echo "127.0.0.1	localhost" > /etc/hosts
ENV STEAMUSER blank
RUN echo "127.0.0.1	mycontainer" >> /etc/hosts && \
echo "/opt/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +login $STEAMUSER +force_install_dir dinos  +app_update 70000 validate +quit" >> /root/install_dinos.sh && \
echo "/opt/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +login $STEAMUSER +force_install_dir dinos  +app_update 70010 validate +quit" >> /root/install_dinos.sh && chmod +x /root/install_dinos.sh

COPY generic.dat /root/.config/q4wine/db/generic.dat
COPY Server.cfg /opt/steamcmd/dinos/Server.cfg
EXPOSE 5901 27015 27005 27020 26901 9877 7777
ENV USER root
CMD [ "/root/start-vncserver.sh" ]

