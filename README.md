# puppetask

A one-command tool to run puppeteer tasks with a linux/amd64 Chromium.

- Runs Chromium in a container
- Opens a VNC window when the process is up and ready
- Automatically passes the CDP socket url to the puppeteer script via env var (`$WS_URL`)




### Quick start

#### Requirements

- Docker 
- vncviewer (automatically installed cross-platform; tested on MacOS)
- Rosetta enabled for Apple Silicon (see below)

#### Running the demo

- Pull the image if you don't want to build it:

    ```
    docker pull teocns/puppetask:chromium-portable
    ```
- Prepare your demo package
    - Run `npm install` within the `./demo` directory
    - Modify `demo/script.js` behavior to your likings.

- Run the task:

    ```
    export CHROMIUM_PATH=/path/to/chromium
    ./run demo/script.js
    ```
    > `CHROMIUM_PATH` must point to a directory containing Chromium build output targeting Linux/x86_64. Will be mounted as volume to the container.
### For ARM (Apple Silicon) chip:

Ensure you have Rosetta enabled.

For simplicity, use `desktop-linux` [Docker Desktop] as the docker context - it's easier to enable the feature from GUI.


```
~/puppetest [j1] $ docker context use desktop-linux
~/puppetest [j1] $ docker context ls
NAME                TYPE                DESCRIPTION                               DOCKER ENDPOINT                                KUBERNETES ENDPOINT   ORCHESTRATOR
default             moby                Current DOCKER_HOST based configuration   unix:///var/run/docker.sock                                          
desktop-linux *     moby                Docker Desktop                            unix:///Users/yeah/.docker/run/docker.sock          
```
