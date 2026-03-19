{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [pkgs.equibop];

  xdg.configFile."equibop/settings.json".text = ''
    {
        "MINIMIZE_TO_TRAY": true,
        "arRPC": false,
        "discordBranch": "canary",
        "splashBackground": "rgb(30, 30, 46)",
        "splashColor":"rgb(186, 194, 222)",
        "splashTheming": true,
        "staticTitle": false,
        "clickTrayToShowHide": true
    }

  '';
}
