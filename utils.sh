#!/usr/bin/env bash

install_ubuntu() {
  if ! dpkg -l | grep -q 'xtightvncviewer'; then
    sudo apt update
    sudo apt install -y xtightvncviewer
  fi
}

install_centos() {
  if ! rpm -q tigervnc; then
    sudo yum update
    sudo yum install -y tigervnc
  fi
}

install_mac() {
  if ! brew list | grep -q 'tiger-vnc'; then
    brew install tiger-vnc
  fi
}

install_deps_ifneeded(){
  echo "Detecting operating system..."
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ -f "/etc/os-release" ]]; then
      . /etc/os-release
      [[ "$ID" == "ubuntu" || "$ID" == "debian" ]] && install_ubuntu
      [[ "$ID" == "centos" || "$ID" == "rhel" ]] && install_centos
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac
  else
    echo "Unsupported OS."
    exit 1
  fi
}




wait_for_chromium() {
  echo "Waiting for Chromium to start..."
  local container=$(docker ps -lq)
  docker logs -f $container & logspid=$!
  while ! curl -s http://localhost:9222/json/version > /dev/null; do
    sleep 0.1
  done
  kill $logspid
  # Get the websocket url
  export WS_URL=$(curl -s http://localhost:9222/json/version | jq -r '.webSocketDebuggerUrl')
  echo 'Chromium started. To view output, run:
  '"docker logs -f $container"
}
