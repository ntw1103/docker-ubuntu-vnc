README
======

This creates a Docker container with Ubuntu 18.04 and [TightVNC Server](https://tightvnc.com).

DDD Server instructions: 
```bash
export VNCPASSWORD=*SOMEPASSWORD*
export STEAMUSER=*WHATEVER Your steam username is*

git clone https://github.com/ntw1103/docker-ubuntu-vnc.git
cd docker-ubuntu-vnc
docker build -t vnc .
docker run --network=host -td vnc

User a vnc client toconnect to the sever
The password is password
Once connected click on the start menu ->  System Tools -> LX Terminal

In the terminal run:

/root/install_dinos.sh
#You will be prompted for your steam password for steamCMD.
#If you have steam guard, you will be prompted for your 2fa.
#it will take a little bit, as it installs Dino D-Day
Once that has finished, click on the start menu -> System Tools -> q4wine
Click next 4 times, there should be a blank field asking for the Binary path. enter: /usr/bin/wine
Click next until it changes to finish, and click finish.

In the q4wine window, there will be a srcds icon. launch it by double clicking.
For some reason, the first time launch this, it doesn't like connecting to the steam servers, you can relaunch it, and it should work.
At least it did for me. :)

```
To build:

```bash
$ make build
$docker build -t vnc .
```

To run:

```bash
$ make run
```

which is a shorthand for:

```bash
$ docker run --rm -ti -p 5901:5901 --name docker-ubuntu panta/docker-ubuntu-vnc:latest
$ docker run --network=host -td vnc
```

To get a shell on a running container:

```bash
$ make shell
```
