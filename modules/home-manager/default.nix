{
  apps = {
    i3 = ./apps/i3.nix;
    i3status = ./profiles/i3status.nix;
    dunst = ./profiles/dunst.nix;
    gpg = ./profiles/gpg.nix;
    xterm = ./profiles/xterm.nix;
    udiskie = ./profiles/udiskie.nix;
    tmux = ./apps/tmux.nix;
    firefox = ./apps/firefox.nix;
  };
  dev = {
    android = ./dev/android.nix;
    elm = ./dev/elm.nix;
    node = ./dev/node.nix;
    go = ./dev/go.nix;
    haskell = ./dev/haskell.nix;
    python = ./dev/python.nix;
    ruby = ./dev/ruby.nix;
    nix = ./dev/nix.nix;

    # devops tools
    devops = {
      all = ./dev/devops/default.nix;
      cloud = ./dev/devops/cloud.nix;
      containers = ./dev/devops/containers.nix;
      kubernetes = ./dev/devops/kubernetes.nix;
      virt = ./dev/devops/virt.nix;
      tools = ./dev/devops/tools.nix;
    };
  };
  roles = {
    work = ./roles/work.nix;
    crypto = ./roles/crypto.nix;
    dev = ./roles/dev.nix;
  };
  themes = {
    materia-irblack = ./themes/materia-irblack.nix;
  };
}
