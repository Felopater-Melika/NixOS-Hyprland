{
  pkgs,
  config,
  inputs,
  lib,
  options,
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
    ags_1
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
    zed
    eog
    networkmanager-l2tp
    gnome-system-monitor
    prismlauncher
    file-roller
    grim
    devbox
    gitflow
    lavat
    boxes
    blanket
    ponysay
    nyancat
    pokeget-rs
    sl
    pokemonsay
    zellij
    du-dust
    skim
    fd
    ripgrep
    jq
    lolcat
    tty-clock
    cmatrix
    xdragon
    toilet
    fortune
    protonvpn-gui
    hiddify-app
    #  pwvucontrol_git
    xl2tpd # L2TP daemon required
    strongswan
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
    libsForQt5.qtstyleplugin-kvantum # kvantum
    networkmanagerapplet
    catppuccin-cursors.mochaDark
    nwg-look # requires unstable channel
    nwg-dock-hyprland
    wdisplays
    pamixer
    # nvtopPackages.full
    pavucontrol
    playerctl
    polkit_gnome
    pyprland
    libsForQt5.qt5ct
    qt6ct
    qt6.qtwayland
    qt6Packages.qtstyleplugin-kvantum # kvantum
    rofi-wayland
    slurp
    acpi
    ngrok
    swappy
    swww
    unzip
    wallust
    wl-clipboard
    protobuf
    protolint
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
    pnpm
    rustup
    cargo
    clippy
    rustfmt
    rust-analyzer
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
    # bibata-cursors
    gtkmm3
    gtkmm4
    anydesk
    vivid
    (pkgs.callPackage ../../pkgs/nitch.nix {})
    nurl
    # socat
    pkgs.lua52Packages.cjson
    pkgs.lua52Packages.luautf8
    firefox
    microsoft-edge
    lazygit
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.rust-rover
    jetbrains.rider
    android-tools
    android-sdk
    android-studio
  ];
}
