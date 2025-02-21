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
  virtualisation.podman = {
    enable = false;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # extraOptions = [
    #   "--log-driver=json-file"
    #   "--log-level=info"
    # ];
    # daemon.settings = {
    #   data-root = "../../../docker/data";
    #   userland-proxy = false;
    #   experimental = true;
    #   metrics-addr = "0.0.0.0:9323";
    #   ipv6 = true;
    #   fixed-cidr-v6 = "fd00::/80";
    # };
  };
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    # win-virtio
    # win-spice
    adwaita-icon-theme
  ];
  #   virtualisation.containerd.enable = true; # Enables container runtime
  #   virtualisation.containerd.services.kubernetes.enable = true; # Configures containerd for Kubernetes
}
