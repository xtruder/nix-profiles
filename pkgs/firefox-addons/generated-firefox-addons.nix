{ buildFirefoxXpiAddon, fetchurl, stdenv }:
  {
    "clearurls" = buildFirefoxXpiAddon {
      pname = "clearurls";
      version = "1.9.1";
      addonId = "{74145f27-f039-47ce-a470-a662b129930a}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3431654/clearurls-1.9.1-an+fx.xpi?src=";
      sha256 = "1e30fcd11ddfa85e3cd48701660274f8cdb440459b076232ac7feee64978797a";
      meta = with stdenv.lib;
      {
        homepage = "https://gitlab.com/KevinRoebert/ClearUrls";
        description = "Remove tracking elements form URLs.";
        license = licenses.lgpl3;
        platforms = platforms.all;
        };
      };
    "cookie-autodelete" = buildFirefoxXpiAddon {
      pname = "cookie-autodelete";
      version = "3.0.2";
      addonId = "CookieAutoDelete@kennydo.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/1906813/cookie_autodelete-3.0.2-an+fx.xpi?src=";
      sha256 = "ec1abb6ae918a1ad63d3e878cf402dc02dde1e4470b0f4b32a3de29bc8eb003a";
      meta = with stdenv.lib;
      {
        homepage = "https://github.com/mrdokenny/Cookie-AutoDelete";
        description = "Control your cookies! This WebExtension is inspired by Self Destructing Cookies. When a tab closes, any cookies not being used are automatically deleted. Whitelist the ones you trust while deleting the rest. Support for Container Tabs.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "decentraleyes" = buildFirefoxXpiAddon {
      pname = "decentraleyes";
      version = "2.0.13";
      addonId = "jid1-BoFifL9Vbdl2zQ@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3423038/decentraleyes-2.0.13-an+fx.xpi?src=";
      sha256 = "9dd1aa4e752166fb13ddc06068cf4c1aacc7e2789128fa103cf81285818943ea";
      meta = with stdenv.lib;
      {
        homepage = "https://decentraleyes.org";
        description = "Protects you against tracking through \"free\", centralized, content delivery. It prevents a lot of requests from reaching networks like Google Hosted Libraries, and serves local files to keep sites from breaking. Complements regular content blockers.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "disabled-add-on-fix-61-65" = buildFirefoxXpiAddon {
      pname = "disabled-add-on-fix-61-65";
      version = "1.0.6";
      addonId = "hotfix-update-xpi-intermediate@mozilla.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/2855573/disabled_add_on_fix_for_firefox_61_65-1.0.6-fx.xpi?src=";
      sha256 = "1dbc841f060c03b8ae091ac217d8728b79008cc2b334f97d27b4b45da479d896";
      meta = with stdenv.lib;
      {
        homepage = "https://bugzilla.mozilla.org/show_bug.cgi?id=1549017";
        description = "This extension will re-enable extensions that were disabled on May 3, 2019 for Firefox versions 61 - 65.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "greasemonkey" = buildFirefoxXpiAddon {
      pname = "greasemonkey";
      version = "4.9";
      addonId = "{e4a8a97b-f2ed-450b-b12d-ee082ba24781}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3024171/greasemonkey-4.9-an+fx.xpi?src=";
      sha256 = "a3c94257caa11c7ef4c9a61b2d898f82212a017aa3ab07e79bce07f98a25d4f1";
      meta = with stdenv.lib;
      {
        homepage = "http://www.greasespot.net/";
        description = "Customize the way a web page displays or behaves, by using small bits of JavaScript.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "https-everywhere" = buildFirefoxXpiAddon {
      pname = "https-everywhere";
      version = "2019.6.27";
      addonId = "https-everywhere@eff.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/3060290/https_everywhere-2019.6.27-an+fx.xpi?src=";
      sha256 = "37bb2155496910fdcf093c6f40d7871bd9605b4bd0200498b1c7c29b2ca4831c";
      meta = with stdenv.lib;
      {
        homepage = "https://www.eff.org/https-everywhere";
        description = "Encrypt the web! HTTPS Everywhere is a Firefox extension to protect your communications by enabling HTTPS encryption automatically on sites that are known to support it, even when you type URLs or follow links that omit the https: prefix.";
        platforms = platforms.all;
        };
      };
    "mailvelope" = buildFirefoxXpiAddon {
      pname = "mailvelope";
      version = "4.1.1";
      addonId = "jid1-AQqSMBYb0a8ADg@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3390582/mailvelope-4.1.1-fx.xpi?src=";
      sha256 = "01bd5583931278079d1abc4295176795d2a1d0007498ccdf54703083bc9c1055";
      meta = with stdenv.lib;
      {
        homepage = "https://www.mailvelope.com/";
        description = "Enhance your webmail provider with end-to-end encryption. Secure email communication based on the OpenPGP standard.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "octotree" = buildFirefoxXpiAddon {
      pname = "octotree";
      version = "3.0.8";
      addonId = "jid1-Om7eJGwA1U8Akg@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/2988920/octotree-3.0.8-fx.xpi?src=";
      sha256 = "1db1fe9336d2e1fc6ac3bd86a73f8500963b1e70e27d855d0c64ab06790f8a8b";
      meta = with stdenv.lib;
      {
        homepage = "https://github.com/buunguyen/octotree/";
        description = "Add-on to display GitHub code in tree format";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "privacy-badger" = buildFirefoxXpiAddon {
      pname = "privacy-badger";
      version = "2019.10.28";
      addonId = "jid1-MnnxcxisBPnSXQ@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3434057/privacy_badger-2019.10.28-an+fx.xpi?src=";
      sha256 = "c701b5b6b67fc2c11f39f61ebe90075826e1c6158aa5cf1e052ebedad2cdcc66";
      meta = with stdenv.lib;
      {
        homepage = "https://www.eff.org/privacybadger";
        description = "Automatically learns to block invisible trackers.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "pushbullet" = buildFirefoxXpiAddon {
      pname = "pushbullet";
      version = "347";
      addonId = "jid1-BYcQOfYfmBMd9A@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3408174/pushbullet-347-fx.xpi?src=";
      sha256 = "2f8e6d5c2f2ac11a29a158d90e6405cf8c1558eeaea897b7282c7dc602e6b8a0";
      meta = with stdenv.lib;
      {
        homepage = "https://www.pushbullet.com";
        description = "Pushbullet enables you to see your calls and texts on your computer and easily send links and files from your computer to phone.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "save-page-we" = buildFirefoxXpiAddon {
      pname = "save-page-we";
      version = "16.2";
      addonId = "savepage-we@DW-dev";
      url = "https://addons.mozilla.org/firefox/downloads/file/3421167/save_page_we-16.2-fx.xpi?src=";
      sha256 = "0a2227ebf2d65776a7c568a3fbd3bdeaf66aa5459298e56ed109b9eba4151d09";
      meta = with stdenv.lib;
      {
        description = "Save a complete web page (as curently displayed) as a single HTML file that can be opened in any browser. Choose which items to save. Define the format of the saved filename. Enter user comments.";
        license = licenses.gpl2;
        platforms = platforms.all;
        };
      };
    "stylus" = buildFirefoxXpiAddon {
      pname = "stylus";
      version = "1.5.6";
      addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3401561/stylus-1.5.6-fx.xpi?src=";
      sha256 = "4ac675d1b5e2edb837bef2bed6044b9be3a7af24201080728f194e46b1ed025f";
      meta = with stdenv.lib;
      {
        homepage = "https://add0n.com/stylus.html";
        description = "Redesign your favorite websites with Stylus, an actively developed and community driven userstyles manager. Easily install custom themes from popular online repositories, or create, edit, and manage your own personalized CSS stylesheets.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "ublock-origin" = buildFirefoxXpiAddon {
      pname = "ublock-origin";
      version = "1.23.0";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/3428595/ublock_origin-1.23.0-an+fx.xpi?src=";
      sha256 = "b72c8bf1038d18e2d8badd0accd20f9d6938efe2f45303e99aaab189a66dbbc1";
      meta = with stdenv.lib;
      {
        homepage = "https://github.com/gorhill/uBlock#ublock-origin";
        description = "Finally, an efficient blocker. Easy on CPU and memory.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "vertical-tabs-reloaded" = buildFirefoxXpiAddon {
      pname = "vertical-tabs-reloaded";
      version = "0.12.1";
      addonId = "verticaltabsreloaded@go-dev.de";
      url = "https://addons.mozilla.org/firefox/downloads/file/1177683/vertical_tabs_reloaded-0.12.1-an+fx.xpi?src=";
      sha256 = "098e7ecf12277351858ac05d5cea716e294e45ff8dbc8017ca8cc4bc1c5065ff";
      meta = with stdenv.lib;
      {
        homepage = "https://github.com/Croydon/vertical-tabs-reloaded";
        description = "This Firefox add-on arranges tabs in a vertical rather than horizontal fashion.\n\nHide and display manually the tab sidebar with a hotkey (Ctrl+Shift+V) or by clicking on the VTR icon.";
        license = licenses.mpl20;
        platforms = platforms.all;
        };
      };
    "vimium-ff" = buildFirefoxXpiAddon {
      pname = "vimium-ff";
      version = "1.64.6";
      addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
      url = "https://addons.mozilla.org/firefox/downloads/file/2985278/vimium_ff-1.64.6-fx.xpi?src=";
      sha256 = "7044bd3983e541faf2e56c117048fdc281c4c52e4196472fc4f9e4af42c5e1da";
      meta = with stdenv.lib;
      {
        homepage = "https://github.com/philc/vimium";
        description = "The Hacker's Browser. Vimium provides keyboard shortcuts for navigation and control in the spirit of Vim.\n\nThis is a port of the popular Chrome extension to Firefox.\n\nMost stuff works, but the port to Firefox remains a work in progress.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    }