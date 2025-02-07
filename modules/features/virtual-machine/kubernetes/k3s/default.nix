{
  inputs,
  settings,
  pkgs,
  ...
}: let
  generateManifests = import ../lib/generateManifests.nix {inherit inputs settings pkgs;};
  generateHostEntries = import ../lib/generateHostEntries.nix {inherit settings;};

  # List of services to deploy
  services = [
    # "immich"
    # "baserow"
    # "jellyfin"
    # "pairdrop"
    # "portainer"
    # "rsshub"
  ];

  # Generate manifests for services
  manifests = generateManifests services;

  # Generate host entries for services
  extraHosts = generateHostEntries services;
in {
  services = {
    k3s = {
      enable = true;
      role = "server";
      inherit manifests;
      extraFlags = "--disable traefik=false"; # Explicitly enable Traefik
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        # Kubernetes API server
        6443
        # Kubelet API
        10250
        # HTTP for Traefik ingress
        80
        # HTTPS for Traefik ingress
        443
        1714
        1715
        1716
        1717
        1718
        1719
        1720
        1721
        1722
        1723
        1724
        1725
        1726
        1727
        1728
        1729
        1730
        1731
        1732
        1733
        1734
        1735
        1736
        1737
        1738
        1739
        1740
        1741
        1742
        1743
        1744
        1745
        1746
        1747
        1748
        1749
        1750
        1751
        1752
        1753
        1754
        1755
        1756
        1757
        1758
        1759
        1760
        1761
        1762
        1763
        1764
      ];
      allowedUDPPorts = [
        # Flannel VXLAN
        8472

        1714
        1715
        1716
        1717
        1718
        1719
        1720
        1721
        1722
        1723
        1724
        1725
        1726
        1727
        1728
        1729
        1730
        1731
        1732
        1733
        1734
        1735
        1736
        1737
        1738
        1739
        1740
        1741
        1742
        1743
        1744
        1745
        1746
        1747
        1748
        1749
        1750
        1751
        1752
        1753
        1754
        1755
        1756
        1757
        1758
        1759
        1760
        1761
        1762
        1763
        1764
      ];
    };

    inherit extraHosts;
  };

  # environment = {
  #   systemPackages = with pkgs; [
  #     kubernetes-helm
  #   ];
  # };
}
