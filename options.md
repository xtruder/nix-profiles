* `attributes.admin.email`:

  Admin email

  **Default:** "..."
  **Example:** ...

* `attributes.admin.fullname`:

  Admin fullname

  **Default:** "..."
  **Example:** ...

* `attributes.cpu.cores`:

  Number of CPU cores

  **Default:** "..."
  **Example:** ...

* `attributes.name`:

  Name of the server

  **Default:** "..."
  **Example:** ...

* `attributes.privateIPv4`:

  Private networking address.

  **Default:** "127.0.0.1"
  **Example:** ...

* `attributes.projectName`:

  Name of the project

  **Default:** "..."
  **Example:** ...

* `attributes.publicIPv4`:

  Public networking address.

  **Default:** ""
  **Example:** ...

* `attributes.recoveryKey`:

  SSH recovery key

  **Default:** "..."
  **Example:** ...

* `attributes.recoveryPassword`:

  Recovery password

  **Default:** "..."
  **Example:** ...

* `attributes.smtp.from`:

  Email to send mails from

  **Default:** "..."
  **Example:** ...

* `attributes.smtp.host`:

  SMTP host for sending emails

  **Default:** "smtp.gmail.com"
  **Example:** ...

* `attributes.smtp.password`:

  SMTP password

  **Default:** ""
  **Example:** ...

* `attributes.smtp.port`:

  Port to use for smtp

  **Default:** 587
  **Example:** ...

* `attributes.smtp.username`:

  SMTP username

  **Default:** "..."
  **Example:** ...

* `profiles.docker.enable`:

  Whether to enable docker profile.

  **Default:** false
  **Example:** true

* `profiles.i3.background`:

  Background image to use

  **Default:** "szkzdvg2lu5x.png"
  **Example:** ...

* `profiles.i3.enable`:

  Whether to enable i3 profile.

  **Default:** false
  **Example:** ...

* `profiles.i3.primaryMonitor`:

  Identifier of the primary monitor

  **Default:** "eDP1"
  **Example:** ...

* `profiles.i3.secondaryMonitor`:

  Identifier of the secondary monitor

  **Default:** "HDMI1"
  **Example:** ...

* `profiles.i3.terminal`:

  Command to start terminal

  **Default:** "st -c \"sucklessterm\" -e tmux attach"
  **Example:** ...

* `profiles.kubernetes.enable`:

  Whether to enable kubernetes profile.

  **Default:** false
  **Example:** true

* `profiles.st.enable`:

  Whether to enable suckless terminal.

  **Default:** false
  **Example:** true

* `profiles.terminal.run`:

  Command to run to start terminal

  **Default:** "tmux attach"
  **Example:** ...

* `profiles.terminal.term`:

  TERM to set

  **Default:** "secreen-256color"
  **Example:** ...

* `profiles.tmux.enable`:

  Whether to enable tmux profile.

  **Default:** false
  **Example:** true

* `profiles.vbox.enable`:

  Whether to enable docker profile.

  **Default:** false
  **Example:** true

* `profiles.wireshark.enable`:

  Whether to enable wireshark profile.

  **Default:** false
  **Example:** true

* `profiles.x11.Xresources`:

  Additional xresources

  **Default:** ""
  **Example:** ...

* `profiles.x11.compositor`:

  Whether to enable compositor.

  **Default:** false
  **Example:** true

* `profiles.x11.cursorTheme`:

  Cursor theme name

  **Default:** "Numix"
  **Example:** ...

* `profiles.x11.displayManager`:

  Whether to enable display manager.

  **Default:** false
  **Example:** true

* `profiles.x11.enable`:

  Whether to enable x11 server profile.

  **Default:** false
  **Example:** true

* `profiles.x11.gtk2.settings`:

  Extra settings for gtk2

  **Default:** ""
  **Example:** ...

* `profiles.x11.gtk2.theme`:

  GTK2 theme name

  **Default:** "Clearlooks"
  **Example:** ...

* `profiles.x11.gtk3.settings`:

  Extra settings for gtk3

  **Default:** ""
  **Example:** ...

* `profiles.x11.gtk3.theme`:

  GTK2 theme name

  **Default:** "Clearlooks"
  **Example:** ...

* `profiles.x11.iconTheme`:

  Icon theme name

  **Default:** "Numix"
  **Example:** ...

* `profiles.x11.qt.settings`:

  QT theme settings

  **Default:** ""
  **Example:** ...

* `profiles.x11.qt.theme`:

  QT theme name

  **Default:** "Fusion"
  **Example:** ...

* `roles.admin.enable`:

  Whether to enable admin role.

  **Default:** false
  **Example:** true

* `roles.anonymous.enable`:

  Whether to enable anonymous role.

  **Default:** false
  **Example:** true

* `roles.anonymous.routeTraffic`:

  Whether route traffic through tor

  **Default:** true
  **Example:** ...

* `roles.anonymous.whitelistAddresses`:

  List of adddresses to whitelist

  **Default:** ["127.0.0.0/8","10.0.0.0/8","172.16.0.0/12","192.168.0.0/16","0.0.0.0/8","100.64.0.0/10","169.254.0.0/16","192.0.0.0/24","192.0.2.0/24","192.88.99.0/24","198.18.0.0/15","198.51.100.0/24","203.0.113.0/24","224.0.0.0/3"]
  **Example:** ...

* `roles.desktop.enable`:

  Whether to enable desktop role.

  **Default:** false
  **Example:** true

* `roles.dev.android.enable`:

  Whether to enable android development.

  **Default:** false
  **Example:** true

* `roles.dev.enable`:

  Whether to enable dev role.

  **Default:** false
  **Example:** true

* `roles.dev.go.enable`:

  Whether to enable go language.

  **Default:** false
  **Example:** true

* `roles.dev.nix.enable`:

  Whether to enable nix language.

  **Default:** false
  **Example:** true

* `roles.dev.node.enable`:

  Whether to enable node language.

  **Default:** false
  **Example:** true

* `roles.dev.python.enable`:

  Whether to enable python development.

  **Default:** false
  **Example:** true

* `roles.headless.enable`:

  Whether to enable development profile

  **Default:** false
  **Example:** ...

* `roles.headless.mmap`:

  Whether to use direct memory access for faster transport

  **Default:** true
  **Example:** ...

* `roles.laptop.enable`:

  Whether to enable laptop role.

  **Default:** false
  **Example:** true

* `roles.multimedia.enable`:

  Whether to enable multimedia role.

  **Default:** false
  **Example:** true

* `roles.office.enable`:

  Whether to enable office role.

  **Default:** false
  **Example:** true

* `roles.pentest.enable`:

  Whether to enable pentest role.

  **Default:** false
  **Example:** true

* `roles.system.enable`:

  Whether to enable system role.

  **Default:** false
  **Example:** true

* `roles.vm.enable`:

  Whether to enable vm role.

  **Default:** false
  **Example:** true

* `roles.work.enable`:

  Whether to enable work role.

  **Default:** false
  **Example:** true
