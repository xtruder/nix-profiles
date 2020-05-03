{ lib, symlinkJoin, writeScriptBin
, runtimeShell, i3, sway, jq, bemenu
, useSway ? false
, promptCmd ? prompt: ''echo "" | ${bemenu}/bin/bemenu -p "${prompt}: "''}:

with lib;

let
  msgcmd = if useSway then "${sway}/bin/swaymsg" else "${i3}/bin/i3-msg";
  jqcmd = "${jq}/bin/jq";

  renameWorkspace = writeScriptBin "i3-rename-workspace" ''
	  #!${runtimeShell} -el

    name=`${msgcmd} -t get_workspaces | ${jqcmd} 'map(select(.focused == true))[0].name'`
    num=`${msgcmd} -t get_workspaces | ${jqcmd} 'map(select(.focused == true))[0].num'`
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

    export WORKSPACE=''${WORKSPACE:-$(${msgcmd} -t get_workspaces  | ${jqcmd} '.[] | select(.focused==true).name | split(":") | .[1]' -r)}

    if [ "$WORKSPACE" == "null" ]; then
      unset WORKSPACE
    fi

    exec $@
  '';

in symlinkJoin {
  name = "i3-scripts";
  paths = [ renameWorkspace exposeWorkspace ];
}
