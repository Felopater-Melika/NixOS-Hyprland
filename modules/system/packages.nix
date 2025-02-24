{
  pkgs,
  config,
  inputs,
  lib,
  chaotic,
  android-nixpkgs,
  system,
  ...
}: let
  android-sdk = inputs.android-nixpkgs.sdk.${system} (sdkPkgs:
    with sdkPkgs; [
      cmdline-tools-latest
      build-tools-34-0-0
      platform-tools
      platforms-android-34
      emulator
    ]);
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
    softether
    delta
    cliphist
    kdePackages.qtsvg
    kdePackages.qtmultimedia
    kdePackages.qtvirtualkeyboard
    eog
    networkmanager-l2tp
    gnome-system-monitor
    prismlauncher
    file-roller
    grim
    xl2tpd # L2TP daemon required
    strongswan
    #  pwvucontrol_git
    gtk-engine-murrine #for gtk themes
    hyprcursor # requires unstable channel
    hypridle # requires unstable channel
    imagemagick
    catppuccin-papirus-folders
    inxi
    gh-dash
    signal-desktop
    python3Full
    python312Packages.pip
    python312Packages.requests
    python312Packages.python-dotenv
    gnome-keyring
    alejandra
    libreoffice
    tor-browser
    gitkraken
    # poetry
    rocmPackages.llvm.clang-unwrapped
    libgccjit
    zoom-us
    libgcc
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
    bun
    acpi
    ngrok
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
    gtk3
    gtk4
    fish
    atuin
    bun
    deno
    nodejs_23
    pnpm
    httpie
    pipx
    rainfrog
    docker-compose
    lazydocker
    arion
    dive
    # podman-tui
    nvd
    discord
    webcord
    nix-output-monitor
    nix-prefetch
    dart-sass
    nodejs
    sassc
    libgtop
    starship
    telegram-desktop
    pre-commit
    helix
    dotnet-sdk_9
    vesktop
    papirus-folders
    perl
    pkg-config
    openssl
    gnumake
    ninja
    cmake
    rdkafka
    cyrus_sasl
    zstd
    # papirus-icon-theme
    spotify
    ungoogled-chromium
    # jetbrains-toolbox
    zoxide
    devenv
    todoist-electron
    bibata-cursors
    gtkmm3
    gtkmm4
    anydesk
    vivid
    spotube
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.rust-rover
    jetbrains.rider
    android-tools
    android-sdk
    android-studio
  ];
}
