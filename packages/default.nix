{
  allowUnfree = true;

  firefox.icedtea = true;

  st.patches = [
    ./st-alpha-20160727-308bfbf.diff
    ./st-solarized-both-20160727-308bfbf.diff
  ];

  st.conf = builtins.readFile ./st.conf;

  packageOverrides = pkgs: {
    bundle = import ./bundles.nix { inherit pkgs; };
  };
}
