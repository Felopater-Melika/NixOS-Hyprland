rec {
  # Git Configuration ( For Pulling Software Repos )

  hostname = "aetherion";
  username = "philo";
  configDirectory = "/home/${username}/NixOS-Hyprland";
  # FIXME: Set this to the exact target disk on the new machine before running Disko.
  # FIXME: Use a stable /dev/disk/by-id path so you do not accidentally wipe the wrong drive.
  installDisk = "/dev/disk/by-id/CHANGE-ME";
  gitUsername = "Felopater-Melika";
  gitEmail = "felopatermelika@gmail.com";

  # Hyprland Settings
  extraMonitorSettings = "";

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "firefox"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "wezterm"; # Set Default System Terminal
  keyboardLayout = "us";
}
