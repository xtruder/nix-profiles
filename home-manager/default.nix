{
  module = ./module.nix;
  profiles = {
    i3 = ./profiles/i3.nix;
    i3status = ./profiles/i3status.nix;
    dunst = ./profiles/dunst.nix;
    gpg = ./profiles/gpg.nix;
    xterm = ./profiles/xterm.nix;
    kitty = ./profiles/kitty.nix;
    udiskie = ./profiles/udiskie.nix;
    tmux = ./profiles/tmux.nix;
    firefox = ./profiles/firefox.nix;
    chromium = ./profiles/chromium.nix;
    git = ./profiles/git.nix;
    gnome-keyring = ./profiles/gnome-keyring.nix;
    rofi = ./profiles/rofi.nix;
    wayland = ./profiles/wayland.nix;
  };
  workspaces = {
    base = ./workspaces/base.nix;
    i3 = ./workspaces/i3.nix;
    sway = ./workspaces/sway.nix;
    gnome3 = ./workspaces/gnome3.nix;
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
    svelte = ./dev/svelte.nix;

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
    base = ./roles/base.nix;
    work = ./roles/work.nix;
    dev = ./roles/dev.nix;
    crypto = ./roles/crypto.nix;
    windows = ./roles/windows.nix;

    desktop = {
      work = ./roles/desktop/work.nix;
      dev = ./roles/desktop/dev.nix;
      crypto = ./roles/desktop/crypto.nix;
    };
  };
  system = {
    laptop = ./system/laptop.nix;
    user-env = ./system/user-env.nix;
  };
  themes = {
    materia = ./themes/materia.nix;
    colorscheme.google-dark = ./themes/colorschemes/google-dark.nix;
  };
}
