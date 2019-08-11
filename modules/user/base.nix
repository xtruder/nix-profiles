{
  config = {
    nixpkgs.overlays = [
      (import ../../pkgs)
    ];

    nixpkgs.config = {
      allowUnfree = true;

      firefox.icedtea = true;
      android_sdk.accept_license = true;
    };

    programs.bash = {
      enable = true;

      # allow user to define extra profile in ~/.userrc file
      profileExtra = ''
        if [ -f ~/.userrc ]; then
          . ~/.userrc
        fi
      '';
    };
    xdg.enable = true;
  };
}
