{
  pkgs,
  config,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  ...
}:
with lib; let
  cfg = config.system.kernel;
in {
  options.system.kernel = {
    enable = mkEnableOption "Enable kernel";
  };

  config = mkIf cfg.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages_cachyos;
      consoleLogLevel = 0;
      kernelParams = [
        "nowatchdog"
        "plymouth.enable=1"
        "quiet"
        "splash"
        "loglevel=3"
        "modprobe.blacklist=iTCO_wdt"
        "nohibernate"
        "nvidia-drm.modeset=1"
      ];
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      initrd.verbose = false;
    };
  };
}
