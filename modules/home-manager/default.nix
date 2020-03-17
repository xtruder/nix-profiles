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
    git = ./apps/git.nix;
  };
  workspaces = {
    i3 = ./workspaces/i3.nix;
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
  environments = {
    base = ./environments/base.nix;
    work = ./environments/work.nix;
    dev = ./environments/dev.nix;
    crypto = ./environments/crypto.nix;
    windows = ./environments/windows.nix;

    desktop = {
      work = ./environments/desktop/work.nix;
      dev = ./environments/desktop/dev.nix;
      crypto = ./environments/desktop/crypto.nix;
    };
  };
  themes = {
    materia = ./themes/materia.nix;
    colorscheme.google-dark = ./themes/colorschemes/google-dark.nix;
  };
}
