# vncify

Build on top of an existing Docker image to add VNC capabilities.

## Build

After cloning or downloading this repository:
```bash
cd vncify
docker build -t [image]_vnc:1.0 --build-arg IMAGEBASE=[image] .
```

In the above command, replace `[image]` with the name of the base image you want to use.

The default username is assumed to be `cmsusr`. This can be changed by adding the following to the above command:
`--build-arg USERNAME=[user]`.

<details>
<summary>More generic command:</summary>

```bash
cd vncify
docker build -t [name]:[version] --build-arg IMAGEBASE=[base_name]:[base_version] .
```
where `[name]`, `[version]`, `[base_name]`, `[base_version]` can all be specified if desired.
</details>

## Run

```bash
docker run -P -p 5901:5901 -p 6080:6080 ... [image]_vnc:1.0
```
where `...` is the rest of your usual `docker run` command.
(Optionally, a command to run inside the container like `/bin/bash` can be appended to this command.)

## Use VNC

To launch a VNC server, run this command: `start_vnc`

(For verbose output, use `startvnc verbose`.)

The first time you start a server, or after a cleanup, you will be asked to setup a password. It must be at least six characters in length.

Configuration Options:

* You can use the `GEOMETRY` environment variable to set the size of the VNC window. By default it is set to 1920x1080.
* If you run multiple VNC servers you can switch desktops by changing the `DISPLAY` environment variable like so: `export DISPLAY=myvnc:1`,
which will set the display of the remote machine to that of the VNC server.

At this point, you can connect to the VNC server with your favorite VNC viewer (TigerVNC, RealVNC, TightVNC, OSX built-in VNC viewer, etc.).
The following are the connection addresses:

* VNC viewer address: 127.0.0.1:5901
* OSX built-in VNC viewer command: `open vnc://127.0.0.1:5901`
* Web browser URL: http://127.0.0.1:6080/vnc.html?host=127.0.0.1&port=6080

Note: On OSX you will need to go to System Preferences > Sharing and turn on "Screen Sharing" if using a VNC viewer, built-in or otherwise.
You will not need to do this if using the browser.

There are two additional helper functions:

* `stop_vnc`: kill all of the running vnc servers and the noVNC+WebSockify instance
* `clean_vnc`: run `stop_vnc` and clear all temporary files associated with the previous vnc servers

If you'd like more manual control you can use the following commands:

* `vncserver -list`: list the available VNC servers running on the remote machine.
* `vncserver -kill :1`: kill a currently running VNC server using. `:1` is the "X DISPLAY #".
* `pkill -9 -P <process>`: kill the noVNC+WebSockify process if you use the PID given when running `start_vnc` or when starting manually.

## Compatibility

The Dockerfile is based on RHEL Linux distributions.

WebSockify only works correctly with Python 2.7 or higher. Images with older Python versions will not support the "web browser" view.
(Traditional VNC viewers can still be used.)
