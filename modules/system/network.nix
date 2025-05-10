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
}: {
  networking.networkmanager.enable = true;
  networking.networkmanager.package = pkgs.networkmanager;
  networking.hostName = "${host}";
  networking.timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
  networking.firewall.enable = false;
}
