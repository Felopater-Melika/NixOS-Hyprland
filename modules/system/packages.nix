{
  pkgs,
  config,
  inputs,
  lib,
  chaotic,
  ...
}: let
  sddmThemes = import ./../../pkgs/sddm.nix {
    stdenv = pkgs.stdenv;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  };
in {
  environment.systemPackages = with pkgs; [
    (ags.overrideAttrs (oldAttrs: {
      inherit (oldAttrs) pname;
      version = "1.8.2";
    }))
    brightnessctl # for brightness control
    libinput
    libinput-gestures
    nautilus
    cliphist
    kdePackages.qtsvg
    kdePackages.qtmultimedia
    kdePackages.qtvirtualkeyboard
    eog
    gnome-system-monitor
    prismlauncher
    file-roller
    grim
    pwvucontrol_git
    gtk-engine-murrine #for gtk themes
    hyprcursor # requires unstable channel
    hypridle # requires unstable channel
    imagemagick
    catppuccin-papirus-folders
    inxi
    gh-dash
    signal-desktop
    zoom-us
    warp-terminal
    brave
    jq
    magnetic-catppuccin-gtk
    catppuccin-gtk
    catppuccin-qt5ct
    catppuccin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    kitty
    libsForQt5.qtstyleplugin-kvantum #kvantum
    networkmanagerapplet
    catppuccin-cursors.mochaDark
    nwg-look # requires unstable channel
    # nwg-dock-hyprland
    wdisplays
    nvtopPackages.full
    pamixer
    pavucontrol
    playerctl
    polkit_gnome
    pyprland
    libsForQt5.qt5ct
    qt6ct
    qt6.qtwayland
    qt6Packages.qtstyleplugin-kvantum #kvantum
    rofi-wayland
    slurp
    swappy
    swww
    unzip
    wallust
    wl-clipboard
    wlogout
    yad
    yt-dlp
    nix-ld
    power-profiles-daemon
    fd
    home-manager
    bluez-tools
    wgpu-utils
    gtk3
    gtk4
    fish
    atuin
    bun
    deno
    nodejs_23
    pnpm
    rustup
    cargo
    rust-analyzer
    clippy
    rustfmt
    httpie
    pipx
    rainfrog
    docker-compose
    lazydocker
    arion
    dive
    podman-tui
    nvd
    nix-output-monitor
    nix-prefetch
    dart-sass
    nodejs
    sassc
    libgtop
    starship
    telegram-desktop
    pre-commit
    vesktop
    # papirus-folders
    # papirus-icon-theme
    spotify
    jetbrains-toolbox
    # (pkgs.callPackage ../../pkgs/sddm-astronaut-theme.nix {
    #   theme = "japanese_aesthetic";
    # })
    sddmThemes.tokyo-night
    zoxide
    todoist-electron
    bibata-cursors
    firefox_nightly
  ];
}
