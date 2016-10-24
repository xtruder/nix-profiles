* `attributes.admins`:

  List of admins

  **Default:** "..."
  **Example:** ...

* `attributes.admins.*.email`:

  Admin email

  **Default:** "..."
  **Example:** ...

* `attributes.admins.*.key`:

  Admin ssh key

  **Default:** "..."
  **Example:** ...

* `attributes.admins.*.notify`:

  Whether to notify admin about events on the server

  **Default:** true
  **Example:** ...

* `attributes.checks`:

  System wide checks.

  **Default:** {}
  **Example:** ...

* `attributes.checks.<name>.name`:

  Service name.

  **Default:** ""
  **Example:** ...

* `attributes.clusterNodes`:

  List of nodes to cluster with

  **Default:** []
  **Example:** ...

* `attributes.domain`:

  Project domain

  **Default:** "dummy-project"
  **Example:** ...

* `attributes.emailFrom`:

  Email to send mails from

  **Default:** "admin@x-truder.net"
  **Example:** ...

* `attributes.nameservers`:

  List of nameservers.

  **Default:** ["8.8.8.8","8.8.4.4"]
  **Example:** ...

* `attributes.privateIPv4`:

  Private networking address.

  **Default:** "127.0.0.1"
  **Example:** ...

* `attributes.privateInterface`:

  Interface for private network.

  **Default:** "eth1"
  **Example:** ...

* `attributes.projectName`:

  Name of the project

  **Default:** "dummy-project"
  **Example:** ...

* `attributes.publicIPv4`:

  Public networking address.

  **Default:** ""
  **Example:** ...

* `attributes.publicInterface`:

  Interface for public network.

  **Default:** "eth0"
  **Example:** ...

* `attributes.recoveryKey`:

  SSH recovery key

  **Default:** ""
  **Example:** ...

* `attributes.services`:

  Definition for service profiles.

  **Default:** {}
  **Example:** ...

* `attributes.services.<name>.checkFailure`:

  List of services to check for failure

  **Default:** []
  **Example:** ...

* `attributes.services.<name>.checks`:

  Definitions for service checks.

  **Default:** {}
  **Example:** ...

* `attributes.services.<name>.checks.<name>.interval`:

  Interval that script is run.

  **Default:** "10m"
  **Example:** ...

* `attributes.services.<name>.checks.<name>.name`:

  Check name.

  **Default:** ""
  **Example:** ...

* `attributes.services.<name>.checks.<name>.script`:

  Check script to run.

  **Default:** "..."
  **Example:** ...

* `attributes.services.<name>.host`:

  Host where service listens.

  **Default:** "127.0.0.1"
  **Example:** ...

* `attributes.services.<name>.name`:

  Service name.

  **Default:** ""
  **Example:** ...

* `attributes.services.<name>.port`:

  Port Where service listens.

  **Default:** null
  **Example:** ...

* `attributes.services.<name>.proxy.enable`:

  whether to enable http proxy to service.

  **Default:** false
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

* `attributes.tags`:

  Tags associated with node

  **Default:** []
  **Example:** ...

* `attributes.terminal`:

  Terminal to use

  **Default:** "/nix/store/p950is4bmnr2fn65g7gm02ph29bbq5gh-st-0.7/bin/st -c \"sucklessterm\" -e /nix/store/0zfb79bwh8riq9j7chwm8vxw5k042a3j-tmux-2.3/bin/tmux"
  **Example:** ...

* `profiles.desktop.enable`:

  Whether to enable desktop profile.

  **Default:** false
  **Example:** ...

* `profiles.dev.enable`:

  Whether to enable development profile

  **Default:** false
  **Example:** ...

* `profiles.dnscrypt.enable`:

  Whether to enable dnscrypt profile.

  **Default:** false
  **Example:** ...

* `profiles.etcd.discovery`:

  Etcd discovery url.

  **Default:** "..."
  **Example:** ...

* `profiles.etcd.enable`:

  Whether to enable to enable etcd profile..

  **Default:** false
  **Example:** true

* `profiles.gtk.enable`:

  Whether to enable gtk profile

  **Default:** false
  **Example:** ...

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

  **Default:** "/nix/store/p950is4bmnr2fn65g7gm02ph29bbq5gh-st-0.7/bin/st -c \"sucklessterm\" -e /nix/store/0zfb79bwh8riq9j7chwm8vxw5k042a3j-tmux-2.3/bin/tmux"
  **Example:** ...

* `profiles.kubernetes.enable`:

  Whether to enable Whether to enable kubernetes profile..

  **Default:** false
  **Example:** true

* `profiles.kubernetes.master`:

  Wheter node is master

  **Default:** false
  **Example:** ...

* `profiles.kubernetes.network.domain`:

  Kubernetes domain name for skydns.

  **Default:** "dummy-project"
  **Example:** ...

* `profiles.kubernetes.network.interface`:

  Kubernetes interface.

  **Default:** "kbr"
  **Example:** ...

* `profiles.kubernetes.network.ipAddress`:

  Ip address for kubernetes network.

  **Default:** "10.244.1.1"
  **Example:** ...

* `profiles.kubernetes.network.prefixLength`:

  Kubernetes network prefix length.

  **Default:** 24
  **Example:** ...

* `profiles.kubernetes.network.servicesSubnet`:

  Subnet for services.

  **Default:** "10.255.1.0/24"
  **Example:** ...

* `profiles.kubernetes.network.subnet`:

  Kubernetes network subnet.

  **Default:** "10.244.0.0/16"
  **Example:** ...

* `profiles.kubernetes.node`:

  Wheter node is a compute node

  **Default:** false
  **Example:** ...

* `profiles.kubernetes.registries`:

  Attribute set of docker registries

  **Default:** "..."
  **Example:** ...

* `profiles.kubernetes.registries.*.auth`:

  Docekr registry auth.

  **Default:** ""
  **Example:** ...

* `profiles.kubernetes.registries.*.email`:

  Docker registry email

  **Default:** ""
  **Example:** ...

* `profiles.kubernetes.registries.*.url`:

  Docker registry url

  **Default:** "..."
  **Example:** ...

* `profiles.kubernetes.tokens`:

  Attribute set of username and passwords

  **Default:** {}
  **Example:** ...

* `profiles.monitoring.collectd.enable`:

  Whether to enable collectd profile.

  **Default:** false
  **Example:** ...

* `profiles.monitoring.collectd.influxdbHost`:

  Influxdb host

  **Default:** "localhost"
  **Example:** ...

* `profiles.monitoring.collectd.influxdbPort`:

  Influxdb port

  **Default:** 25826
  **Example:** ...

* `profiles.monitoring.onfailure.command`:

  Command to execute on failure.

  **Default:** ""
  **Example:** ...

* `profiles.monitoring.onfailure.enable`:

  Whether to enable monitoring.

  **Default:** false
  **Example:** ...

* `profiles.monitoring.onfailure.services`:

  List of services to monitor.

  **Default:** []
  **Example:** ...

* `profiles.x11.enable`:

  Whether to enable Whether to enable x11 server profile..

  **Default:** false
  **Example:** true
