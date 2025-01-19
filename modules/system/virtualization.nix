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
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # extraOptions = [
    #   "--log-driver=json-file"
    #   "--log-level=info"
    # ];
    daemon.settings = {
      data-root = "../../../docker/data";
      userland-proxy = false;
      experimental = true;
      metrics-addr = "0.0.0.0:9323";
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80";
    };
  };

  #   virtualisation.containerd.enable = true; # Enables container runtime
  #   virtualisation.containerd.services.kubernetes.enable = true; # Configures containerd for Kubernetes
}
