{ buildFirefoxXpiAddon, fetchurl, stdenv }:
  {
    "clearurls" = buildFirefoxXpiAddon {
      pname = "clearurls";
      version = "1.15.0";
      addonId = "{74145f27-f039-47ce-a470-a662b129930a}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3507273/clearurls-1.15.0-an+fx.xpi?src=";
      sha256 = "533307f9f81deb605e9943ed8509f68477bdb53313e8c33745e3db5aceaddcff";
      meta = with stdenv.lib;
      {
        homepage = "https://gitlab.com/KevinRoebert/ClearUrls";
        description = "Remove tracking elements from URLs.";
        license = licenses.lgpl3;
        platforms = platforms.all;
        };
      };
    "cookie-autodelete" = buildFirefoxXpiAddon {
      pname = "cookie-autodelete";
      version = "3.0.3";
      addonId = "CookieAutoDelete@kennydo.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/3496777/cookie_autodelete-3.0.3-an+fx.xpi?src=";
      sha256 = "f1d45073817e94e6473272d98c8d2652df9e510ad5f71e2c4202b8cc50fc76e1";
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
      version = "2019.11.7";
      addonId = "https-everywhere@eff.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/3442258/https_everywhere-2019.11.7-an+fx.xpi?src=";
      sha256 = "b4c33fcc43f9da395ff0b139cec005afa43f007c45a991d6089402c0b78288e6";
      meta = with stdenv.lib;
      {
        homepage = "https://www.eff.org/https-everywhere";
        description = "Encrypt the web! HTTPS Everywhere is a Firefox extension to protect your communications by enabling HTTPS encryption automatically on sites that are known to support it, even when you type URLs or follow links that omit the https: prefix.";
        platforms = platforms.all;
        };
      };
    "mailvelope" = buildFirefoxXpiAddon {
      pname = "mailvelope";
      version = "4.2.1";
      addonId = "jid1-AQqSMBYb0a8ADg@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3482061/mailvelope-4.2.1-fx.xpi?src=";
      sha256 = "4a8ab01ddc2808414da8711d2c0b0a34eb43f3a00e1638ea1ebbbb0bf5d73944";
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
      version = "4.1.6";
      addonId = "jid1-Om7eJGwA1U8Akg@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3510077/octotree-4.1.6-fx.xpi?src=";
      sha256 = "41ecb69dc9bbfa12af7779cb74e7dc194450f7ca73542305c757f70f3a4d5697";
      meta = with stdenv.lib;
      {
        homepage = "https://github.com/buunguyen/octotree/";
        description = "GitHub on steroids";
        platforms = platforms.all;
        };
      };
    "privacy-badger" = buildFirefoxXpiAddon {
      pname = "privacy-badger";
      version = "2020.2.19";
      addonId = "jid1-MnnxcxisBPnSXQ@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3509922/privacy_badger-2020.2.19-an+fx.xpi?src=";
      sha256 = "4030aebff2e538e3cd637a7d2c5cea4d3f3817cc10e171891abd505ef67b5ac7";
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
      version = "353";
      addonId = "jid1-BYcQOfYfmBMd9A@jetpack";
      url = "https://addons.mozilla.org/firefox/downloads/file/3475863/pushbullet-353-fx.xpi?src=";
      sha256 = "254c55ee80201a70e9ea120fc29f71a816735f81a011827a39b4d5be78a8db7c";
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
      version = "16.7";
      addonId = "savepage-we@DW-dev";
      url = "https://addons.mozilla.org/firefox/downloads/file/3506897/save_page_we-16.7-fx.xpi?src=";
      sha256 = "338ec05773d97523c8f34f65994ea32a960ac2b71ef48e04abcba716cded69e3";
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
      version = "1.24.4";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/3498086/ublock_origin-1.24.4-an+fx.xpi?src=";
      sha256 = "062a8dd4044e3cd7d96b189758de576e1a0fbd1c01833fb44b4efc05ccf0320e";
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
      version = "1.65.1";
      addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3502765/vimium_ff-1.65.1-fx.xpi?src=";
      sha256 = "10afafcdb0e4ec64b8ccc96f9142a664807efc66fdafe83e2692fd7c7750b87c";
      meta = with stdenv.lib;
      {
        homepage = "https://github.com/philc/vimium";
        description = "The Hacker's Browser. Vimium provides keyboard shortcuts for navigation and control in the spirit of Vim.\n\nThis is a port of the popular Chrome extension to Firefox.\n\nMost stuff works, but the port to Firefox remains a work in progress.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    }