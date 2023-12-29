{pkgs, ...}:

{
    services.xserver = {
        enable = true;
        displayManager.sddm = {
            enable = true;
        };
        desktopManager.plasma5.enable = true;
        #xrandrHeads = [
        #    "eDP"
        #    {
        #        output = "eDP";
        #        primary = true;
        #        monitorConfig = ''
        #            Option "PreferredMode" "2560x1600"
        #        '';
        #    }
        #    "HDMI-1-0"
        #    {
        #        output = "HDMI-1-0";
        #        monitorConfig = ''
        #            Option "Above" "eDP"
        #            Option "PreferredMode" "1920x1080"
        #        '';
        #    }
        #];
    };
}