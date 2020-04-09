{
  # start homepage at startup
  "browser.startup.page" = 1;

  "browser.library.activity-stream.enabled" = false;

  # geo logging to console
  "geo.wifi.logging.enabled" = true;

  # disable auto-CHECKING for extension and theme updates
  "extensions.update.enabled" = false;

  # disable auto-INSTALLING extension and theme updates
  "extensions.update.autoUpdateDefault" = false;

  # disable saving passwords
  "signon.rememberSignons" = false;

  # disable GMP (Gecko Media Plugins)
  "media.gmp-provider.enabled" = false;

  # don't fingerprint my battery
  "dom.battery.enabled" = false;

  # don't need VR
  "dom.vr.enabled" = false;

  # disable websites overriding Firefox's keyboard shortcuts
  "permissions.default.shortcuts" = 2;

  # download to last location
  "browser.download.folderList" = 2;

  # disable open with dialog
  "browser.download.forbid_open_with" = true;

  # disable sensor API
  "device.sensors.enabled" = false;

  # disable gamepad API
  "dom.gamepad.enabled" = false;

  # enable gfx font rendering
  "gfx.downloadable_fonts.enabled" = true;

  # disable letterboxing protection
  "privacy.resistFingerprinting.letterboxing" = false;

  # enable website choosing fonts
  "browser.display.use_document_fonts" = 1;

  # make clearOnShutdown less strict
  "privacy.clearOnShutdown.cache" = false;
  "privacy.clearOnShutdown.cookies" = false;
  "privacy.clearOnShutdown.downloads" = true;
  "privacy.clearOnShutdown.formdata" = true;
  "privacy.clearOnShutdown.history" = false;
  "privacy.clearOnShutdown.offlineApps" = false;
  "privacy.clearOnShutdown.sessions" = false;
  "privacy.clearOnShutdown.siteSettings" = false;

  # allow stylesheets
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

  # expose magnet files
  "network.protocol-handler.expose.magnet" = true;

  # ask site by site whether to allow autoplay
  "media.autoplay.default" = 2;
  "media.autoplay.ask-permission" = true;
  "media.autoplay.enabled.user-gestures-needed" = false;

  "layers.acceleration.force-enabled" = true;

  # enable webrender
  "gfx.webrender.enabled" = true;
  "gfx.gfx.font_rendering.graphite.enabled" = true;
  "gfx.font_rendering.opentype_svg.enabled" = true;
}
