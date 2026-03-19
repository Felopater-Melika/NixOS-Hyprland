{
  pkgs,
  config,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  #   darkmatter-theme,
  ...
}:
with lib; let
  cfg = config.system.bootloader;
in {
  options.system.bootloader = {
    enable = mkEnableOption "Enable Bootloader";
  };

  config = mkIf cfg.enable {
    # catppuccin.grub.enable = true;
    # catppuccin.grub.flavor = "mocha";
    boot = {
      loader.efi = {
        canTouchEfiVariables = true;
      };
      loader.timeout = 3;
      loader.grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        memtest86.enable = true;
        extraGrubInstallArgs = ["--bootloader-id=${host}"];
        # configurationName = "${host}";
        gfxmodeEfi = "2560x1440";
        useOSProber = true;
        extraEntries = ''
          menuentry "Fallback Kernel (Standard NixOS)" {
              linux ${pkgs.linuxPackages.kernel.out}/bzImage
              initrd ${pkgs.linuxPackages.kernel.out}/initrd
          }
        '';
        theme = pkgs.catppuccin-grub;
        # darkmatter-theme = {
        #   enable = true;
        #   style = "nixos";
        #   icon = "color";
        #   resolution = "1440p";
        # };
        configurationLimit = 8;
      };
      tmp = {
        useTmpfs = false;
        tmpfsSize = "30%";
      };
      binfmt.registrations.appimage = {
        wrapInterpreterInShell = true;
        interpreter = "${pkgs.appimage-run}/bin/appimage-run";
        recognitionType = "magic";
        offset = 0;
        mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
        magicOrExtension = ''\x7fELF....AI\x02'';
      };
    };
  };
}
