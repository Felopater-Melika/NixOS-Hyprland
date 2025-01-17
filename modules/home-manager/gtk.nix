{
  pkgs,
  config,
  inputs,
  ...
}: {
  catppuccin.gtk = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
    size = "standard";

    gnomeShellTheme = true;
    tweaks = ["normal"];
    icon = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
    };
  };
  gtk = {
    enable = true;

    # iconTheme = {
    #   name = "Papirus-Dark";
    #   packages = pkgs.papirus-icon-theme;
    # };
    # theme.packages = pkgs.catppuccin-gtk.override {
    #   accents = ["dark"]; # You can specify multiple accents here to output multiple themes
    #   size = "standard";
    #   variant = "mocha";
    # };
    #     theme.name = "catppuccin-mocha-blue";
    #     gtk3.extraConfig = {
    #       gtk-application-prefer-dark-theme = 1;
    #     };
    #     gtk4.extraConfig = {
    #       gtk-application-prefer-dark-theme = 1;
    #     };
    #     font = {
    #       name = "JetBrainsMono Nerd Font";
    #       size = 14;
    #     };
  };
}
