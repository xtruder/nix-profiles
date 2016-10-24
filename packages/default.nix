{
  allowUnfree = true;

  chromium.enableGoogleTalkPlugin = true;
  chromium.enablePepperFlash = true;
  chromium.enableWideVine = true;

  firefox.icedtea = true;

  packageOverrides = pkgs: {
    bundles = import ./bundles.nix { inherit pkgs; };
  };
}
