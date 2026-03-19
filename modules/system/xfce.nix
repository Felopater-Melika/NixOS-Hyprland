{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.system.xfce;
in {
  options.system.xfce = {
    enable = mkEnableOption "Enable a lightweight XFCE desktop session";
    makeDefaultSession = mkEnableOption "Make XFCE the default SDDM session";
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.xfce.enable = true;

    system.displayManager.defaultSession = mkIf cfg.makeDefaultSession (mkOverride 900 "xfce");
  };
}
