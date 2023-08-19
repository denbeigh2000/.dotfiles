{ config, ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";

      # Always use metric
      AppleICUForce24HourTime = false;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleTemperatureUnit = "Celsius";

      # Never replace any entered characters
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Don't use iCloud
      NSDocumentSaveNewDocumentsToCloud = false;

      # Advanced interface
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      # Hide navbar automatically
      _HIHideMenuBar = true;

      # Old-school scroll direction
      "com.apple.swipescrolldirection" = false;

      # Enable right-click in corner
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
    };

    # Manually install updates
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

    dock = {
      # Autohide dock
      autohide = true;

      # Do not rearrance spaces by most-recently-used
      mru-spaces = false;

      show-recents = false;

      # Disable hot corners
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      # Hide desktop icons
      CreateDesktop = false;

      # Allow Cmd-Q of Finder
      QuitMenuItem = true;

      ShowPathbar = true;
      ShowStatusBar = true;
    };

    loginwindow.GuestEnabled = false;

    screencapture = {
      location = "/Users/${config.denbeigh.user.username}/screenshots";
      type = "png";
    };

    trackpad.TrackpadRightClick = true;
  };
}
