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

* `attributes.tags`:

  Tags associated with node

  **Default:** []
  **Example:** ...

* `profiles.ci.enable`:

  Whether to enable Whether to enable jenkins profile..

  **Default:** false
  **Example:** true

* `profiles.consul.alerts`:

  Whether to enable consul alerts

  **Default:** false
  **Example:** ...

* `profiles.consul.enable`:

  Whether to enable Whether to enable consul profile..

  **Default:** false
  **Example:** true

* `profiles.consul.join`:

  List of nodes to join

  **Default:** {"_type":"override","content":[],"priority":1000}
  **Example:** ...

* `profiles.consul.upstreamDns`:

  Upstream dns server.

  **Default:** ["8.8.8.8","8.8.4.4"]
  **Example:** ...

* `profiles.elasticsearch.enable`:

  Whether to enable elasticsearch.

  **Default:** false
  **Example:** ...

* `profiles.elasticsearch.keystore.password`:

  Secret password for keystore

  **Default:** "..."
  **Example:** ...

* `profiles.elasticsearch.keystore.path`:

  Path for keystore

  **Default:** "..."
  **Example:** ...

* `profiles.elasticsearch.kibana.enable`:

  Wheter to enable kibana.

  **Default:** false
  **Example:** ...

* `profiles.elasticsearch.truststore.password`:

  Secret password for keystore

  **Default:** "..."
  **Example:** ...

* `profiles.elasticsearch.truststore.path`:

  Path to trustore

  **Default:** "..."
  **Example:** ...

* `profiles.etcd.discovery`:

  Etcd discovery url.

  **Default:** "..."
  **Example:** ...

* `profiles.etcd.enable`:

  Whether to enable to enable etcd profile..

  **Default:** false
  **Example:** true

* `profiles.kube-vpn.certPath`:

  Path to server cert file.

  **Default:** "..."
  **Example:** ...

* `profiles.kube-vpn.dhPath`:

  Path to dh12 parameters

  **Default:** "/run/secrets/dh1024.pem"
  **Example:** ...

* `profiles.kube-vpn.dns`:

  Kubernetes dns server

  **Default:** "10.244.1.1"
  **Example:** ...

* `profiles.kube-vpn.enable`:

  Whether to enable enable kubernese vpn access.

  **Default:** false
  **Example:** true

* `profiles.kube-vpn.interface`:

  Vpn interface to create.

  **Default:** "kbr-vpn"
  **Example:** ...

* `profiles.kube-vpn.searchDomain`:

  Domain to search

  **Default:** "dummy-project"
  **Example:** ...

* `profiles.kube-vpn.serviceRoute`:

  Route to access kubernetes services

  **Default:** "10.255.1.0 255.255.255.0 10.244.1.1"
  **Example:** ...

* `profiles.kube-vpn.vpnSubnet`:

  Subnet for VPN.

  **Default:** "10.244.100.1 255.255.0.0 10.244.100.1 10.244.100.255"
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

* `profiles.kubernetes.registry.auth`:

  Docekr registry auth.

  **Default:** ""
  **Example:** ...

* `profiles.kubernetes.registry.url`:

  Docker registry url.

  **Default:** ""
  **Example:** ...

* `profiles.kubernetes.tokens`:

  Attribute set of username and passwords

  **Default:** {}
  **Example:** ...

* `profiles.logstash.elasticsearch.bind_host`:

  Host for elasticsearch.

  **Default:** "127.0.0.1"
  **Example:** ...

* `profiles.logstash.elasticsearch.bind_port`:

  Port for elasticsearch.

  **Default:** 9400
  **Example:** ...

* `profiles.logstash.elasticsearch.cluster_name`:

  Elasticsearch cluster name.

  **Default:** "dummy-project"
  **Example:** ...

* `profiles.logstash.elasticsearch.keystore`:

  Keystore for logstash in JKS format

  **Default:** "..."
  **Example:** ...

* `profiles.logstash.enable`:

  Whether to enable Whether to enable logstash master profile..

  **Default:** false
  **Example:** true

* `profiles.logstash.prefix`:

  Kibana nginx prefix.

  **Default:** "/kibana"
  **Example:** ...

* `profiles.metrics.bosun.emailTo`:

  List of addresses to send email to

  **Default:** []
  **Example:** ...

* `profiles.metrics.bosun.enable`:

  Whether to enable bosun

  **Default:** true
  **Example:** ...

* `profiles.metrics.bosun.influxHost`:

  Influxdb host

  **Default:** "localhost:8086"
  **Example:** ...

* `profiles.metrics.bosun.smtp.emailFrom`:

  Smtp email address

  **Default:** "..."
  **Example:** ...

* `profiles.metrics.bosun.smtp.host`:

  Smtp host

  **Default:** "smtp.gmail.com:587"
  **Example:** ...

* `profiles.metrics.bosun.smtp.password`:

  Password for smtp server

  **Default:** "..."
  **Example:** ...

* `profiles.metrics.bosun.smtp.username`:

  Username for smtp server

  **Default:** "..."
  **Example:** ...

* `profiles.metrics.enable`:

  Whether to enable Whether to enable monitoring profile..

  **Default:** false
  **Example:** true

* `profiles.metrics.grafana.domain`:

  Grafana domain.

  **Default:** "grafana.dummy-project"
  **Example:** ...

* `profiles.metrics.grafana.enable`:

  Whether to enable grafana.

  **Default:** true
  **Example:** ...

* `profiles.metrics.influxdb.db`:

  Influxdb database.

  **Default:** "stats"
  **Example:** ...

* `profiles.metrics.influxdb.enable`:

  Whether to enable influxdb.

  **Default:** true
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

* `profiles.nginx.config`:

  Nginx config.

  **Default:** ""
  **Example:** ...

* `profiles.nginx.corsAllowHeaders`:

  List of allowed headers for cors.

  **Default:** []
  **Example:** ...

* `profiles.nginx.corsAllowOrigin`:

  Allowed origin for cors.

  **Default:** "*"
  **Example:** ...

* `profiles.nginx.enable`:

  Whether to enable Whether to enable nginx profile..

  **Default:** false
  **Example:** true

* `profiles.nginx.proxy.domain`:

  Nginx proxy domain suffix.

  **Default:** "dummy-project"
  **Example:** ...

* `profiles.nginx.proxy.enable`:

  Whether to enable proxy for defined services.

  **Default:** false
  **Example:** ...

* `profiles.nginx.snippets`:

  Nginx config snippets.

  **Default:** "..."
  **Example:** ...

* `profiles.ripple.enable`:

  Whether to enable Whether to enable ripple profile..

  **Default:** false
  **Example:** true

* `profiles.vswitch.enable`:

  Whether to enable Whether to enable vswitch profile..

  **Default:** false
  **Example:** true

* `profiles.vswitch.interfaces`:

  Attribute set of local interfaces.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.interfaces.<name>.bridgeTo`:

  Bridge to interface.

  **Default:** ""
  **Example:** ...

* `profiles.vswitch.interfaces.<name>.interface`:

  Name of the internal tun interface.

  **Default:** "tun-"
  **Example:** ...

* `profiles.vswitch.interfaces.<name>.networks`:

  List of networks that interface is connected to.

  **Default:** []
  **Example:** [{"remote":"node0","subnet":"10.244.2.1/24"}]

* `profiles.vswitch.interfaces.<name>.networks.*.remote`:

  Name of the remote.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.interfaces.<name>.networks.*.subnet`:

  Subnet ip.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.interfaces.<name>.port`:

  OpenVswitch port if of interface.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.interfaces.<name>.subnet`:

  Interface subnet.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.remotes`:

  Attribute set of vswitch networks.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.remotes.<name>.name`:

  Name of the remote

  **Default:** ""
  **Example:** ...

* `profiles.vswitch.remotes.<name>.port`:

  OpenVswitch port id.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.remotes.<name>.psk`:

  IPSec pre shared key for a connection.

  **Default:** "..."
  **Example:** ...

* `profiles.vswitch.remotes.<name>.remoteIp`:

  Node remote ip.

  **Default:** "..."
  **Example:** ...

* `profiles.x11.enable`:

  Whether to enable Whether to enable x11 server profile..

  **Default:** false
  **Example:** true
