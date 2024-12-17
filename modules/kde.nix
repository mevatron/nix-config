{config, pkgs, ...}:

{
  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
    };

    displayManager = {
      sddm = {
        enable = true;
      };
    };
  };

  systemd.services.plasma-powerdevil = {
    serviceConfig.TimeoutSec = "15s";
  };
}