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
}:
with lib; let
  cfg = config.system.kernel;
in {
  options.system.kernel = {
    enable = mkEnableOption "Enable kernel";
  };

  config = mkIf cfg.enable {
    boot = {
      #   consoleLogLevel = 5;
      kernelPackages = pkgs.linuxPackages_cachyos;
      consoleLogLevel = 0;
      kernelParams = [
        # "quiet"
        # "splash"
        # "boot.shell_on_fail"
        # "loglevel=3"
        # "rd.udev.log_level=3"
        # "rd.systemd.show_status=false"
        # "udev.log_priority=3"
        # "systemd.mask=systemd-vconsole-setup.service"
        # "systemd.mask=dev-tpmrm0.device"
        "nowatchdog"
        # "amdgpu.dc=1"
        "plymouth.enable=1"
        "quiet"
        "splash"
        "loglevel=3"
        "amdgpu.dc=1"
        "mem_sleep_default=deep"
        "modprobe.blacklist=iTCO_wdt"
        "nohibernate"
      ];
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      initrd = {
        verbose = false;
        availableKernelModules = ["xhci_pci" "ahci" "amdgpu" "nvme" "usb_storage" "usbhid" "sd_mod"];
        kernelModules = ["amdgpu" "asus_wmi" "asus_nb_wmi"];
      };
    };
  };
}
