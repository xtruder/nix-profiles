{ lib, symlinkJoin, writeScriptBin
, runtimeShell, i3, sway, jq, bemenu
, useSway ? false
, promptCmd ? prompt: ''echo "" | ${bemenu}/bin/bemenu -p "${prompt}: "''}:

with lib;

let
  msgcmd = if useSway then "swaymsg" else "i3-msg";

  pkg = if useSway then sway else i3;

  renameWorkspace = writeScriptBin "i3-rename-workspace" ''
	  #!${runtimeShell} -el
    PATH=${makeBinPath [ jq pkg ]}

    name=`${msgcmd} -t get_workspaces | jq 'map(select(.focused == true))[0].name'`
    num=`${msgcmd} -t get_workspaces | jq 'map(select(.focused == true))[0].num'`
    new_name=`${promptCmd "New name"}`

    # if name is not empty do rename
    if [ ! -z $new_name ]; then
      ${msgcmd} "rename workspace $name to $num:$new_name"
    else
      ${msgcmd} "rename workspace $name to $num"
    fi
  '';

  # exposes name of the workspace via environment variable
  exposeWorkspace = writeScriptBin "i3-expose-workspace" ''
    #!${runtimeShell} -el
    PATH=${makeBinPath [ jq pkg ]}:$PATH

    export WORKSPACE=''${WORKSPACE:-$(${msgcmd} -t get_workspaces  | jq '.[] | select(.focused==true).name | split(":") | .[1]' -r)}

    if [ "$WORKSPACE" == "null" ]; then
      unset WORKSPACE
    fi

    exec $@
  '';

in symlinkJoin {
  name = "i3-scripts";
  paths = [ renameWorkspace exposeWorkspace ];
}
