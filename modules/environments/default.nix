{ config, lib, pkgs, ... }:

with lib;

let
  buildEnv = configs: (import <nixpkgs/nixos/lib/eval-config.nix> {
    inherit (config.nixpkgs) system;
    modules = [ ./qemu-vm.nix ] ++ configs;
  }).config.system;
 
in {
  options = {
    environments = mkOption {
      description = "Attribute set of environments";
      type = types.attrsOf (types.submodule ({config, name, ...}: {
        options = {
          name = mkOption {
            description = "Name of the environment";
            type = types.str;
            default = name;
          };

          config = mkOption {
            description = "Environment configuration";
            type = types.attrs;
          };

          ports = mkOption {
            description = "Attribute set of exposed ports";
            default = {};
            type = types.attrsOf (types.submodule ({config, name, ...}: {
              options = {
                port = mkOption {
                  description = "Port in vm";
                  type = types.int;
                };

                hostPort = mkOption {
                  description = "Port on host";
                  type = types.int;
                };
              };
            }));
          };

          memorySize = mkOption {
            type = types.int;
            description = "Memory size for VM";
            default = 2048;
          };
        };
      }));
      default = {};
    };
  };

  config = {
    systemd.services = listToAttrs (map (env: let
      system = buildEnv [env.config {
        config = {
          networking.hostName = mkForce env.name;
          virtualisation = {
            qemu = {
              cpu = ["host" "+vmx"];
              networkingOptions = [
                "-device virtio-net,netdev=user.0"
                "-netdev user,id=user.0,${concatMapStringsSep "," (p:
                  "hostfwd=tcp::${toString p.hostPort}-:${toString p.port}"
                ) (attrValues env.ports)}"
              ];
              options = [
                "-object memory-backend-file,id=mb1,size=256M,share,mem-path=/dev/shm/shm-${env.name}"
                "-device ivshmem-plain,id=ivshm-plain,memdev=mb1"
                "-qmp unix:/var/lib/environments/${env.name}/qmp-sock,server,nowait"
              ];
            };
            graphics = false;
            memorySize = env.memorySize;
            overrideFilesystems = false;
            writableStore = true;
            writableStoreUseTmpfs = false;
          };

          systemd.services.autoupdate = {
            wantedBy = ["multi-user.target"];
            script = ''
              while true; do
                if test $(readlink -f /var/run/current-system) = $(readlink -f /tmp/shared/system); then
                  echo "not updating"
                else
                  /tmp/shared/system/bin/switch-to-configuration test
                fi
                sleep 5
              done
            '';
          };
        };
      }]; 
    in nameValuePair "env-${env.name}" {
      preStart = ''
        mkdir -p /var/lib/environments/${env.name}
        mkdir -p /var/lib/environments/share
        rm /var/lib/environments/${env.name}/share/system || true
        ln -s ${system.build.toplevel} /var/lib/environments/${env.name}/share/system 
      '';
      postStart = ''
        sleep 30
        chmod o+rw /dev/shm/shm-${env.name}
      '';
      environment = {
        SHARED_DIR="/var/lib/environments/share";
      };
      serviceConfig = {
        ExecStart = "${system.build.vm}/bin/run-${env.name}-vm";
        ExecReload = pkgs.writeScript "env-${env.name}-reload.sh" ''
          #!${pkgs.bash}/bin/bash
          rm /var/lib/environments/${env.name}/share/system || true
          ln -s ${system.build.toplevel} /var/lib/environments/${env.name}/share/system 
        '';
        WorkingDirectory = "-/var/lib/environments/${env.name}";
      } // mapAttrs' (name: port: nameValuePair "X-Port-${name}" port.hostPort) env.ports;
      reloadIfChanged = true;
    }) (attrValues config.environments));

    boot.kernelParams = [
      "kvm.ignore_msrs=1" # make osx work
      "kvm-intel" "kvm-intel.nested=1"
    ];
  };
}
