rec {
  # Git Configuration ( For Pulling Software Repos )

  hostname = "aetherion";
  username = "philo";
  configDirectory = "/home/${username}/NixOS-Hyprland";
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
