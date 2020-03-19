{ system }:

let
  pkgsNixfmt = import (fetchTarball {
		url = "https://github.com/NixOS/nixpkgs/archive/b5f5c97f7d67a99b67731a8cfd3926f163c11857.tar.gz";
		sha256 = "1m9xb3z3jxh0xirdnik11z4hw95bzdz7a4p3ab7y392345jk1wgm";
	}) { system = system; config = {}; overlays = [
				(self: super: {
					haskell = super.haskell // {
						packages = super.haskell.packages // {
							ghc864 = super.haskell.packages.ghc864.extend (hself: hsuper: {
								happy = super.haskell.lib.dontCheck (hsuper.callHackage "happy" "1.19.9" {});
							});
						};
					};
				})
			]; };

in import (builtins.fetchTarball {
  url = "https://github.com/serokell/nixfmt/archive/v0.4.0.tar.gz";
  sha256 = "0d15lrd17b7ji3zyzk8pfrmllql1i0xw90nldjs7yd882qqc3bi7";
}) {
  pkgs = pkgsNixfmt;
}
