# Expects a mounted volume at /usr/src/app containing the Chromium binary

FROM --platform=linux/amd64 debian:bullseye-slim



ENV DEBIAN_FRONTEND=noninteractive

# Install Chromium dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  gconf-service \
  libasound2 \
  libatk1.0-0 \
  libc6 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgcc1 \
  libgconf-2-4 \
  libgdk-pixbuf2.0-0 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libstdc++6 \
  libgbm1 \
  libx11-6 \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  ca-certificates \
  fonts-liberation \
  libappindicator1 \
  libnss3 \
  lsb-release \
  xdg-utils \
  wget \
  socat \
  supervisor \
  xvfb \
  dbus-x11 \
  libcairo2 \
  libxcb1 \
  libxrandr2 \
  libxv1 \
  libopus0 \
  libvpx6 \
  fonts-noto-color-emoji \
  fonts-takao-mincho \
  fonts-wqy-zenhei xfonts-intl-chinese xfonts-wqy \
  tigervnc-standalone-server tigervnc-xorg-extension \
  fonts-wqy-microhei \
  wmctrl \
  x11-xserver-utils; 


#
# install neko chromium
RUN set -eux; \
    echo "deb http://ftp.de.debian.org/debian bookworm main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends unzip chromium chromium-common chromium-sandbox openbox; \
    #
    # install widevine module
    CHROMIUM_DIR="/usr/lib/chromium"; \
    WIDEVINE_VERSION=$(wget --quiet -O - https://dl.google.com/widevine-cdm/versions.txt | tail -n 1); \
    wget -O /tmp/widevine.zip "https://dl.google.com/widevine-cdm/${WIDEVINE_VERSION}-linux-x64.zip"; \
    mkdir -p "${CHROMIUM_DIR}/WidevineCdm/_platform_specific/linux_x64"; \
    unzip -p /tmp/widevine.zip LICENSE.txt > "${CHROMIUM_DIR}/WidevineCdm/LICENSE"; \
    unzip -p /tmp/widevine.zip manifest.json > "${CHROMIUM_DIR}/WidevineCdm/manifest.json"; \
    unzip -p /tmp/widevine.zip libwidevinecdm.so > "${CHROMIUM_DIR}/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so"; \
    find "${CHROMIUM_DIR}/WidevineCdm" -type d -exec chmod 0755 '{}' \;; \
    find "${CHROMIUM_DIR}/WidevineCdm" -type f -exec chmod 0644 '{}' \;; \
    rm /tmp/widevine.zip;

VOLUME /etc/puppetask/chromium



#
# set custom user
ARG USERNAME=puppetask
ARG USER_UID=1000
ARG USER_GID=$USER_UID

    # create a non-root user
RUN groupadd --gid $USER_GID $USERNAME; \
    useradd --uid $USER_UID --gid $USERNAME --shell /bin/bash --create-home $USERNAME; \
    #
    # workaround for an X11 problem: http://blog.tigerteufel.de/?p=476
    mkdir /tmp/.X11-unix; \
    chmod 1777 /tmp/.X11-unix; \
    chown root /tmp/.X11-unix/; \
    #
    # make directories for puppetask
    mkdir -p /etc/puppetask /var/log/puppetask \
        /tmp/runtime-$USERNAME \
        /home/$USERNAME/.local/share/xorg; \
    chmod 1777 /var/log/puppetask; \
    chown $USERNAME /var/log/puppetask/ /tmp/runtime-$USERNAME; \
    chown -R $USERNAME:$USERNAME /home/$USERNAME;



COPY dbus /usr/bin/dbus
COPY supervisord.conf /etc/supervisor/supervisord.conf

ENV DISPLAY=:99.0
ENV XDG_RUNTIME_DIR=/tmp/runtime-root
ENV USER=$USERNAME



# Expose CDP port for external connections
EXPOSE 9222

# Expose the VNC port for external connections
EXPOSE 5999

WORKDIR /etc/puppetask/chromium/

COPY ./launchcmd /etc/puppetask/launchcmd

COPY --chown=${USERNAME} preferences.json /etc/puppetask/.config/chromium/Default/Preferences


CMD /usr/bin/supervisord -c "/etc/supervisor/supervisord.conf"
