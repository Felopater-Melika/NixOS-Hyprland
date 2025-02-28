{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # Make unfree software explicit

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  #   boot.loader.grub.zfsSupport = true;
  networking.hostId = "e6ff0de6";
  networking.hostName = "aetherion";
  nixpkgs.config.allowUnfree = true;
  #   boot.supportedFilesystems = ["zfs"];
  #   boot.zfs.package = pkgs.zfs_unstable;
  #   services.zfs.autoSnapshot.enable = true;
  #   services.zfs.autoScrub.enable = true;
  time.timeZone = "America/Chicago";
  networking.networkmanager.enable = true;
  #  networking.nameservers = [ "1.0.0.1" "1.1.1.1" ];
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    openssh
    curl
    pciutils
  ];
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      emojione
      noto-fonts
      #  noto-fonts-cjk
      #  noto-fonts-extra
      #  inconsolata
      #  material-icons
      #  liberation_ttf
      dejavu_fonts
      #   terminus_font
      #   siji
      unifont
    ];
    fontconfig.defaultFonts = {
      monospace = [
        "DejaVu Sans Mono"
      ];
      sansSerif = [
        "DejaVu Sans"
        "Noto Sans"
      ];
      serif = [
        "DejaVu Serif"
        "Noto Serif"
      ];
    };
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.philo = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  nix = {
    package = pkgs.lix;
    settings = {
      allowed-users = ["root" "@wheel" "philo"];
      trusted-users = ["root" "@wheel" "philo" "@builders"];
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  #system.copySystemConfiguration = true;
  system.stateVersion = "25.05"; # Did you read the comment?
}
