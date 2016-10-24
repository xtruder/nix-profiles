{ config, ... }: {
  boot.kernelParams = [
    "kvm.ignore_msrs=1" # make osx work
  ];
}
