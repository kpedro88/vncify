#!/bin/bash

start_vnc() {
    nvnc=$((`vncserver -list | wc -l`-4))
    vncname="myvnc:$(($nvnc+1))"
    desktop="`hostname`:$(($nvnc+1))"
    vncserver -geometry $GEOMETRY -name $vncname
    export ORIGINAL_DISPLAY=$DISPLAY
    export DISPLAY=$desktop
    if [[ "${1}" == "verbose" ]]; then
	/usr/local/novnc/utils/launch.sh --vnc 127.0.0.1:5901 &
    else
	/usr/local/novnc/utils/launch.sh --vnc 127.0.0.1:5901 > /dev/null 2>&1 &
    fi
    export NOVNCPID=$!
    echo -e "VNC connection points:"
    echo -e "\tVNC viewer address: 127.0.0.1:$((5900+$nvnc+1))"
    echo -e "\tOSX built-in VNC viewer command: open vnc://127.0.0.1:$((5900+$nvnc+1))"
    echo -e "\tWeb browser URL: http://127.0.0.1:6080/vnc.html?host=127.0.0.1&port=6080"
    echo -e "\nTo stop noVNC enter 'pkill -9 -P $NOVNCPID'"
    echo -e "To kill the vncserver enter 'vncserver -kill :$(($nvnc+1))'"
}

stop_vnc() {
    nvnc=$((`vncserver -list | wc -l`-4))
    for i in $(seq 1 $nvnc); do
	vncserver -kill :${i}
    done
    pkill -9 -P $NOVNCPID
    unset NOVNCPID
    export DISPLAY=$ORIGINAL_DISPLAY
}

clean_vnc() {
    output=$(ps -p "$NOVNCPID")
    if [[ "$?" -eq 0 ]]; then
	stop_vnc
    fi
    rm ~/.vnc/*.log ~/.vnc/config ~/.vnc/passwd
}
