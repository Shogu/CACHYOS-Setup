/***********************************************************************
 * Interface / UI / Promotions
 **********************************************************************/
user_pref("gfx.webrender.compositor", true);
user_pref("ui.key.menuAccessKey", 0);
user_pref("apz.overscroll.enabled", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.uitour.enabled", false);
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.profiles.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.compactmode.show", true);
user_pref("browser.privateWindowSeparation.enabled", false);

/***********************************************************************
 * Session
 **********************************************************************/
user_pref("browser.sessionstore.interval", 600000);
user_pref("browser.sessionstore.max_tabs_undo", 12);
user_pref("browser.sessionstore.restore_on_demand", true);
user_pref("browser.sessionhistory.max_total_viewers", 4);

/***********************************************************************
 * Développement / Accessibilité / DevTools
 **********************************************************************/
user_pref("devtools.f12_enabled", false);
user_pref("devtools.chrome.enabled", false);
user_pref("devtools.debugger.remote-enabled", false);
user_pref("devtools.toolbox.selected-tool", "");
user_pref("devtools.webide.enabled", false);
user_pref("devtools.webconsole.enabled", false);
user_pref("devtools.inspector.enabled", false);
user_pref("devtools.memory.enabled", false);
user_pref("devtools.netmonitor.enabled", false);
user_pref("devtools.performance.enabled", false);
user_pref("devtools.storage.enabled", false);
user_pref("devtools.webide.autoinstallADBExtension", false);
user_pref("devtools.webide.autoinstallFxdtAdapters", false);
user_pref("devtools.browserconsole.enabled", false);
user_pref("devtools.command-button-paintflashing.enabled", false);
user_pref("devtools.errorconsole.enabled", false);
user_pref("devtools.layoutview.enabled", false);
user_pref("devtools.scratchpad.enabled", false);
user_pref("devtools.toolbar.visible", false);
user_pref("devtools.devedition.enabled", false);
user_pref("devtools.onboarding.telemetry.logged", false);
user_pref("accessibility.force_disabled", 1);
user_pref("dom.gamepad.enabled", false);
user_pref("dom.gamepad.extensions.enabled", false);
user_pref("dom.w3c_touch_events.enabled", 0);
user_pref("media.webspeech.synth.enabled", false);
user_pref("reader.parse-on-load.enabled", false);

/***********************************************************************
 * Extensions / Contenus / Privacy
 **********************************************************************/
user_pref("extensions.screenshots.disabled", true);
user_pref("privacy.userContext.enabled", false);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);

/***********************************************************************
 * Réseau / HTTP / Cache
 **********************************************************************/
user_pref("image.mem.decode_bytes_at_a_time", 131072);
user_pref("browser.cache.disk.parent_directory", "/run/user/1000/firefox");
user_pref("browser.frames-lazy-load.enabled", false);
user_pref("nglayout.initialpaint.delay", 0);
user_pref("general.useragent.override", "Mozilla/5.0 (Wayland; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36");
user_pref("network.dnsCacheExpiration", 3600);
user_pref("network.buffer.cache.count", 48);
user_pref("network.http.max-persistent-connections-per-server", 8);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);
user_pref("network.http.request.max-start-delay", 5);
user_pref("network.prefetch-next", true);
user_pref("network.http.spdy.enabled", false);
user_pref("network.http.spdy.enabled.v3-1", false);
user_pref("network.http.spdy.enabled.deps", false);
user_pref("network.predictor.enable-prefetch", true);
user_pref("network.ssl_tokens_cache_capacity", 32768);
user_pref("privacy.partition.network_state", false);
user_pref("javascript.options.concurrent_multiprocess_gcs.cpu_divisor", 8);


/***********************************************************************
 * Médias / Vidéo / Streaming
 **********************************************************************/
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.gmp.decoder.multithreaded", true);
user_pref("media.gmp.decoder.preferred", true);
user_pref("media.gmp.encoder.enabled", true);
user_pref("media.gmp.encoder.multithreaded", true);
user_pref("media.gmp.encoder.preferred", true);
user_pref("media.memory_cache_max_size", 262144);
user_pref("media.memory_caches_combined_limit_kb", 1048576);
user_pref("media.cache_readahead_limit", 600);
user_pref("media.cache_resume_threshold", 300);
user_pref("media.navigator.enabled", false);
user_pref("image.cache.size", 10485760);

/***********************************************************************
 * Rapports d'erreur
 **********************************************************************/
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("breakpad.reportURL", "");

/***********************************************************************
 * Recherche / Lens
 **********************************************************************/
user_pref("browser.search.visualSearch.featureGate", true);

/***********************************************************************
 * Vie privée / Historique /clipboard
 **********************************************************************/
user_pref("privacy.history.custom", true);
user_pref("privacy.sanitize.timeSpan", 0);
user_pref("dom.event.clipboardevents.enabled", false);

/***********************************************************************
 * Permissions / Notifications / Géolocalisation
 **********************************************************************/
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.geo", 2);

/***********************************************************************
 * Sécurité / Safebrowsing - protections désactivées
 **********************************************************************/
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref("safebrowsing.enabled", false);
user_pref("browser.safebrowsing.allowOverride", false);
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.debug", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous_host", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.only_top_level", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google.updateURL", "");
user_pref("browser.safebrowsing.provider.google4.dataSharing.enabled", false);
user_pref("browser.safebrowsing.provider.google4.dataSharingURL", "");
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google5.enabled", false);
user_pref("browser.safebrowsing.provider.google5.gethashURL", "");
user_pref("browser.safebrowsing.provider.google5.updateURL", "");
user_pref("browser.safebrowsing.provider.mozilla.gethashURL", "");
user_pref("browser.safebrowsing.provider.mozilla.updateURL", "");
user_pref("browser.safebrowsing.reportPhishURL", "");

/***********************************************************************
 * Télémétrie, rapports, études, crash, suggestions
 **********************************************************************/
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("datareporting.healthreport.logging.consoleEnabled", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.sessions.current.clean", true);
user_pref("datareporting.sessions.current.created", false);
user_pref("datareporting.sessions.current.firstPaint", false);
user_pref("datareporting.sessions.current.main", false);
user_pref("datareporting.sessions.current.startTime", false);
user_pref("datareporting.sessions.previous.0", false);
user_pref("devtools.onboarding.telemetry.logged", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.hybridContent.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", true);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.server", "");
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);

/***********************************************************************
 * Détection automatique portail captif & proxy
 **********************************************************************/
user_pref("network.captive-portal-service.enabled", false);
user_pref("captivedetect.canonicalURL", "");
user_pref("network.notify.checkForProxies", false);











