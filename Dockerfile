ARG IMAGEBASE
FROM ${IMAGEBASE}

ARG USERNAME=cmsusr
ARG GETPYTHON

USER root
ADD scripts/vnc_utils.sh /usr/local/vnc_utils.sh

# avoids: Curl error (60): Peer certificate cannot be authenticated with given CA certificates for ... [SSL certificate problem: unable to get local issuer certificate]
RUN for REPO in mc-extras-x86-64 root-c17-noarch root-c17-x86-64; do yum-config-manager --save --setopt=${REPO}.sslverify=false; done

# install tigervnc server
RUN yum install -y tigervnc-server fluxbox xterm \
 && yum clean all \
 && rm -rf /tmp/.X*

# Install noVNC and WebSockify
RUN wget --no-check-certificate --content-disposition -O /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz https://github.com/novnc/noVNC/tarball/v1.1.0 \
    # --no-check-certificate was necessary for me to have wget not puke about https
    # Curl version: curl -LJO https://github.com/novnc/noVNC/tarball/v1.1.0
    && tar -C /usr/local -xvf /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz \
    && rm /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz \
    && ln -s /usr/local/novnc-noVNC-0e9bdff /usr/local/novnc \
    && git clone https://github.com/novnc/websockify /usr/local/novnc/utils/websockify

# install python 2.7 if requested
COPY scripts/check_python_27.sh /tmp/
RUN chmod +x /tmp/check_python_27.sh && /tmp/check_python_27.sh ${GETPYTHON}

# set up user
RUN if ! id ${USERNAME}; then groupadd ${USERNAME}; useradd -m -s /bin/bash -g ${USERNAME} ${USERNAME}; fi

USER ${USERNAME}
WORKDIR /home/${USERNAME}
RUN mkdir -p /home/${USERNAME}/.vnc
ADD scripts/xstartup /home/${USERNAME}/.vnc/xstartup
RUN echo "source /usr/local/vnc_utils.sh" >> /home/${USERNAME}/.bashrc

ENV GEOMETRY 1920x1080
