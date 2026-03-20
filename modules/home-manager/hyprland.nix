{
  config,
  pkgs,
  inputs,
  ...
}: let
  pointer = config.home.pointerCursor;
in {
  home.sessionVariables = {
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };
  xdg.configFile."hypr/animations".source = ../../configs/hypr/animations;
  xdg.configFile."hypr/configs".source = ../../configs/hypr/configs;
  xdg.configFile."hypr/scripts".source = ../../configs/hypr/scripts;
  xdg.configFile."hypr/UserConfigs".source = ../../configs/hypr/UserConfigs;
  xdg.configFile."hypr/wallust".source = ../../configs/hypr/wallust;
  xdg.configFile."hypr/windowrule.py".source = ../../configs/hypr/windowrule.py;
  xdg.configFile."hypr/hyprlock.conf".source = ../../configs/hypr/hyprlock.conf;
  xdg.configFile."hypr/hyprswitch.css".source = ../../configs/hypr/hyprswitch.css;
  xdg.configFile."hypr/themes/mocha.conf".source = ../../configs/hypr/themes/mocha.conf;
  home.packages = [pkgs.wl-clipboard];
  wayland.windowManager.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };
  wayland.windowManager.hyprland.systemd.enable = false;
  wayland.windowManager.hyprland.extraConfig = ''
    $configs = $HOME/.config/hypr/configs
    source=$configs/Settings.conf
    source=$configs/Keybinds.conf
    $UserConfigs = $HOME/.config/hypr/UserConfigs
    source= $UserConfigs/Startup_Apps.conf
    source= $UserConfigs/ENVariables.conf
    source= $UserConfigs/Monitors.conf
    source= $UserConfigs/WindowRules.conf
    source= $UserConfigs/UserDecorAnimations.conf
    source= $UserConfigs/UserKeybinds.conf
    source= $UserConfigs/UserSettings.conf
    source= $UserConfigs/WorkspaceRules.conf
    source= $HOME/.config/hypr/themes/mocha.conf
    $mainMod = SUPER
  '';
  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, tab, exec, ${pkgs.ags_1}/bin/ags -t 'overview' "
  ];
  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm finalize"
    "${pkgs.hyprpanel}/bin/hyprpanel"
    "hyprctl setcursor ${pointer.name} 32"
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
  ];
  wayland.windowManager.hyprland = {
    plugins = [
      pkgs.hyprlandPlugins.borders-plus-plus
    ];
  };
}
