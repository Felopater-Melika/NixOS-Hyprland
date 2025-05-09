{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home.nix
    ./git.nix
    ./gtk.nix
    ./cava.nix
    ./cliphist.nix
    ./nixy.nix
    ./fhsenv.nix
    ./nvchad.nix
    # ./textfox.nix
    ./nixcord.nix
    ./hyprland.nix
    ./spicetify.nix
    ./vscodium.nix
    ./home-packages.nix
    ./ghostty.nix
    # ./hyprpanel.nix
    ./equibop.nix
    ./variables.nix
    ./zathura.nix
    ./hypridle.nix
    ./anyrun
    ./fabric/default.nix
    ./niri/default.nix
    ./zellij/default.nix
    ./scripts/scripts.nix
    ./qt.nix
  ];
}
