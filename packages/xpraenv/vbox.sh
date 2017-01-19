DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

source $DIR/util.sh

PREFIX="env-"

vbox::environments() {
    vboxes=$(VBoxManage list vms | cut -d '"' -f2 | grep "env")
    envs=$(removeprefix "$vboxes" $PREFIX)

    echo "$envs"
}

vbox::name() {
    echo -n $PREFIX$1
}

vbox::start() {
    vm=$(vbox::name $1)

    VBoxManage startvm $vm --type headless

    if keyId=$(vbox::get $1 "key"); then
        password=$(pass::get $1)
        VBoxManage controlvm $vm addencpassword $keyId <(echo $password)
    fi
}

vbox::isrunning() {
    VBoxManage showvminfo $(vbox::name $1) | grep  "running (since" 2>&1 >/dev/null
    result=$?
    return $result
}

vbox::get() {
    data=$(VBoxManage getextradata $(vbox::name $1) $2)

    if [[ "$data" = *"No value set!" ]]; then
        return 1
    fi

    echo $(echo $data | cut -d " " -f2)
    return 0
}

vbox::set() {
    VBoxManage setextradata $(vbox::name $1) $2 $3
}

vbox::portforward() {
    >&2 echo "setting portforward for app $2: $3 -> $4"
    VBoxManage modifyvm $(vbox::name $1) --natpf1 delete $2 || true 2>&1 >/dev/null
    VBoxManage modifyvm $(vbox::name $1) --natpf1 "$2,tcp,,$3,,$4" 2>&1 >/dev/null
}
