# Main default config
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
}: let
  inherit (import ./variables.nix) browser installDisk keyboardLayout terminal;
  python-packages = pkgs.python3.withPackages (ps:
    with ps; [
      requests
      diagrams
      pyquery
    ]);
  androidSdk = inputs.android-nixpkgs.sdk.${system} (sdkPkgs:
    with sdkPkgs; [
      cmdline-tools-latest
      build-tools-34-0-0
      platform-tools
      platforms-android-34
      emulator
    ]);
in {
  imports = [
    ./hardware.nix
    ./users.nix
    (import ../../disko/aetherion-btrfs.nix {device = installDisk;})
    ../../modules/system
  ];

  nixpkgs.overlays = [
    (final: prev: {
      sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
        pname = "sf-mono-liga-bin";
        version = "dev";
        src = inputs.sf-mono-liga-src;
        dontConfigure = true;
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp -R $src/*.otf $out/share/fonts/opentype/
        '';
      };
    })
  ];
  drivers.nvidia.enable = true;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = true;
  system.kernel.enable = true;
  system.bootloader.enable = true;
  system.plymouth.enable = true;
  system.audio.enable = true;
  system.displayManager.enable = true;
  system.btrfs.enable = true;
  system.xfce.enable = true;
  system.xfce.makeDefaultSession = true;
  system.powermanagement.enable = false;
  system.scheduler.enable = true;
  users = {mutableUsers = true;};

  environment.systemPackages =
    (with pkgs; [
      libva-utils
      mesa
      egl-wayland
      mermaid-cli
      waybar
    ])
    ++ [python-packages androidSdk];

  hardware.graphics.enable = true;
  console.keyMap = "${keyboardLayout}";
  environment.variables = {
    VDPAU_DRIVER = if config.drivers.nvidia.enable then "nvidia" else "va_gl";
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    BROWSER = browser;
    TERMINAL = terminal;
    VISUAL = "nvim";
    GSK_RENDERER = "gl";
    CC = "${pkgs.llvmPackages_15.clang}/bin/clang";
    CXX = "${pkgs.llvmPackages_15.clang}/bin/clang++";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
    ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
    ANDROID_AVD_HOME = "$HOME/.android/avd";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CHROMIUM_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    BRAVE_FLAGS = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    PATH = "$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH";
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    CARGO_PROFILE_DEV_BUILD_OVERRIDE_DEBUG = "true";
  };

  system.stateVersion = "25.05";
}
