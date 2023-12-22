{pkgs, ...}:

{
    services = {
        xserver = {
            enable = true;
            displayManager = {
                ssdm.enable = true;
            };
            desktopManager.plasma5.enable = true;
        };
    };
}