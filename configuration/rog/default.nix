{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../system
  ];

  boot = {
    kernelModules = [
      "kvm-amd"
      "v4l2loopback"
    ];

    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=9 card_label="s23cam" exclusive_caps=1
    '';

    kernelParams = [ "amd_iommu=on" ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    bluetooth.enable = true;
  };

  services = {
    xserver = {
      videoDrivers = [
        "nvidia"
        "amdgpu"
      ];
    };

    supergfxd.enable = true;
    asusd.enable = true;
    power-profiles-daemon.enable = true;

    vnstat.enable = true;

    resolved.enable = true;

    upower.enable = true;

    logind.settings.Login = {
      HandlePowerKey = "ignore";
    };
  };

  networking = {
    hostName = "rog";
    networkmanager.enable = false;
    useDHCP = false;
    useNetworkd = true;
    wireless = {
      enable = false;
      iwd = {
        enable = true;
        settings = {
          General = {
            EnableNetworkConfiguration = true;
            RoamRetryInterval = 15;
          };
          Network = {
            AddressRandomization = "none";
            # NameResolvingService = "systemd";
          };
        };
      };
    };
  };

  systemd = {
    network.networks."20-wireless" = {
      matchConfig.Name = "wlan*";
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
        IPv6PrivacyExtensions = "yes";
      };
      dhcpV4Config.RouteMetric = 20;
    };
    network.networks."10-wired" = {
      matchConfig.Name = [
        "en*"
        "eth*"
        "usb*"
      ];
      networkConfig = {
        DHCP = "yes";
        IPv6PrivacyExtensions = "yes";
      };
      dhcpV4Config.RouteMetric = 10;
    };
  };
}
