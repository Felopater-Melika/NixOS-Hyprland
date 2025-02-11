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
}
: {
  services = {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
      desktopManager.xterm.enable = false;
      desktopManager.runXdgAutostartIfNone = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    smartd = {
      enable = false;
      autodetect = true;
    };

    gvfs.enable = true;
    tumbler.enable = true;
    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    # ngrok = {
    #   enable = true;
    #   extraConfig = {};
    #   extraConfigFiles = [
    #     "~/.config/ngrok/ngrok.yml"
    #   ];
    #   tunnels = {
    #     test = {
    #       proto = "http";
    #       addr = "1234";
    #     };
    #   };
    # };
    libinput.enable = true;
    rpcbind.enable = false;
    nfs.server.enable = false;
    openssh.enable = true;
    blueman.enable = true;

    hypridle = {
      enable = true;
      package = pkgs.hypridle;
    };

    udev.packages = [
      pkgs.android-udev-rules
    ];

    # catppuccin.k9s = {
    #   enable = true;
    #   flavor = "mocha";
    #   transparent = true;
    # };

    #printing = {
    #  enable = false;
    #  drivers = [
    # pkgs.hplipWithPlugin
    #  ];
    #};

    #avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    #};

    #ipp-usb.enable = true;

    #syncthing = {
    #  enable = false;
    #  user = "${username}";
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #};
  };
}
