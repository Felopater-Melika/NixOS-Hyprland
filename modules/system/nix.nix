{
  pkgs,
  inputs,
  system,
  config,
  lib,
  options,
  username,
  host,
  ...
}: {
  nix = {
    package = pkgs.lix;
    settings = {
      allowed-users = ["root" "@wheel" "philo"];
      trusted-users = ["root" "@wheel" "philo" "@builders"];
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
