{
  config,
  pkgs,
  ...
}: {
  catppuccin.kvantum = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
    apply = true;
  };
  qt = {
    enable = true;
    style.package = pkgs.catppuccin-qt5ct;
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
  #   qt = {
  #     enable = true;
  #     platformTheme.name = "gtk";
  #     style.name = "Catppuccin-Mocha-Blue";
  #     style.package = pkgs.catppuccin-gtk;
  #   };
  #   xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
  #     General.theme = "Catppuccin-Mocha-Blue";
  #   };
}
