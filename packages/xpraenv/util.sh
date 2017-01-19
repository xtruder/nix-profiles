export XPRA_SOCKET_TIMEOUT=200
export XPRA_ALLOW_UNENCRYPTED_PASSWORDS=1
PASSPREFIX=private/env/

# gets password for environment
pass::get() {
    echo $(pass $PASSPREFIX/$1)
}

port::findfree() {
	read LOWERPORT UPPERPORT < /proc/sys/net/ipv4/ip_local_port_range
	while :
	do
			PORT="`shuf -i $LOWERPORT-$UPPERPORT -n 1`"
			ss -lpn | grep -q ":$PORT " || break
	done
	echo $PORT
}

xpra::attach() {
    xpra attach tcp:localhost:$1 --encoding=rgb --password-file=<(echo -n $XPRA_PASSWORD)
}

xpra::control() {
    xpra control --password-file=<(echo -n $XPRA_PASSWORD) tcp:localhost:$1 $2 "$3"
}

i3::focusedworkspace() {
    echo $(i3-msg -t get_workspaces | jq -rc '.[] | select( .focused  ) | .name')
}

i3::focusednum() {
    echo $(i3-msg -t get_workspaces | jq -rc '.[] | select( .focused  ) | .num')
}

i3::lastworkspace() {
    echo $(i3-msg -t get_workspaces | jq -rc '.[-1] | .num')
}

i3::rename() {
    focusedName=$(i3::focusedworkspace)
    focusedNum=$(i3::focusednum)
    i3-msg "rename workspace \"$focusedName\" to \"$focusedNum $1\""
}

dmenu::ask() {
    echo $2 | tr " " "\n" | rofi -dmenu -p "$1"
}

callprovider() {
    eval $1::$2 ${@:3}
}

removeprefix() {
    result=();

    for i in $1; do
        result+=("${i#$2}")
    done

    echo "${result[@]}"
}

notify() {
    notify-send "env: $1" "$2" --icon=dialog-information
}
