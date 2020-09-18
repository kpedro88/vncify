FROM cmsopendata/cmssw_5_3_32

USER root
ADD scripts/vnc_utils.sh /usr/local/vnc_utils.sh
# Install noVNC and WebSockify
RUN wget --no-check-certificate --content-disposition -O /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz https://github.com/novnc/noVNC/tarball/v1.1.0 \
    # --no-check-certificate was necessary for me to have wget not puke about https
    # Curl version: curl -LJO https://github.com/novnc/noVNC/tarball/v1.1.0
    && tar -C /usr/local -xvf /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz \
    && rm /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz \
    && ln -s /usr/local/novnc-noVNC-0e9bdff /usr/local/novnc \
    && git clone https://github.com/novnc/websockify /usr/local/novnc/utils/websockify

USER cmsusr
WORKDIR /home/cmsusr
RUN mkdir -p /home/cmsusr/.vnc
ADD scripts/xstartup /home/cmsusr/.vnc/xstartup
RUN echo "source /usr/local/vnc_utils.sh" >> /home/cmsusr/.bashrc
