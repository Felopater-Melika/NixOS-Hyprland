{
  config,
  lib,
  inputs,
  username,
  ...
}:
with lib; let
  cfg = config.system.zram;
in {
  options.system.zram = {
    enable = mkEnableOption "Enable zramSwap Modules";
  };

  config = mkIf cfg.enable {
    swapDevices = [
      {
        device = "/swapfile";
        size = 8192; # Size in MB for an 8GB swap file
      }
    ];

    zramSwap = {
      enable = true;
      priority = 100;
      memoryPercent = 60;
      swapDevices = 1;
      algorithm = "zstd";
    };
  };
}
